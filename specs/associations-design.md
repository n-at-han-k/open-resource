# OpenResource Association System Design

## Current Implementation (Working)

The current system supports three association types:
- **belongs_to**: FK stored in source entity's JSONB
- **has_many**: FK stored in target entities' JSONB (queried with `@>` operator)
- **has_one**: Same as has_many but `.first`

### How It Works

```yaml
# config/resources/post.yml
name: post
attributes:
  - name: title
    type: string
associations:
  - type: belongs_to
    target: author
    foreign_key: author_id
```

```ruby
# Storage in JSONB:
# Post entity: { "title": "Hello", "author_id": 42 }
# Author entity: { "name": "John" }

post.author  # => Finds Author with id=42
author.posts # => Finds Posts where properties @> {"author_id": 42}
```

## Issues with Current Implementation

### 1. Returns Array, Not Relation

**Current** (line 170-176):
```ruby
when "has_many"
  klass.define_method(assoc.name) do
    target_model.unscoped.where(...).to_a  # Returns Array!
  end
end
```

**Problem**: Can't chain queries:
```ruby
author.posts.where(status: "published")  # ERROR: Array doesn't have .where
```

### 2. No Inverse Associations

We have `inverse_of` column but don't create the reverse association automatically.

### 3. No Deep Filtering/Sorting

Can't do: `Post.where(author: { name: "John" })` or `Post.order("author.name")`

### 4. No Association Metadata

Missing:
- `dependent` (cascade delete)
- `polymorphic` flag
- `through` (for many-to-many)
- `conditions` (filtered associations)

## Proposed Improvements

### Phase 1: Return Relations (Critical)

**Change has_many/has_one to return ActiveRecord::Relation:**

```ruby
when "has_many"
  klass.define_method(assoc.name) do
    target_model = DynamicModelFactory.model_for(assoc.target_resource)
    target_model.unscoped.where(resource_id: assoc.target_resource_id)
                .where("properties @> ?", { fk => id }.to_json)  # No .to_a!
  end
end
```

**Benefits**:
- Chainable: `author.posts.where(status: "published").order(:created_at)`
- Lazy loading
- Compatible with Ransack

### Phase 2: Auto-Create Inverse Associations

When defining associations, automatically create the reverse:

```ruby
# If Post belongs_to Author
# Then Author should has_many Posts automatically

# Implementation:
def build_model(resource)
  # ... define associations for this resource ...
  
  # Then create inverse associations on target resources
  associations.each do |assoc|
    if assoc.inverse_of.present?
      # Define reverse association on target model
      target_class = DynamicModelFactory.model_for(assoc.target_resource)
      define_inverse_association(target_class, assoc)
    end
  end
end
```

### Phase 3: Deep Filtering Through Associations

**Goal**: Filter by associated entity attributes

```ruby
# Filter posts where author's name contains "John"
Post.ransack(author_name_cont: "John").result

# Implementation:
# 1. Build join SQL that traverses JSONB
# 2. Rewrite ransack params for nested filtering
```

**Implementation Strategy**:

Add to `DynamicModelFactory`:

```ruby
define_singleton_method(:build_association_joins) do |association_path|
  # association_path: "author" or "author.company"
  joins = []
  current_class = self
  
  association_path.split('.').each do |assoc_name|
    assoc = current_class.associations.find { |a| a.name == assoc_name }
    break unless assoc
    
    # Build JSONB join condition
    target_model = DynamicModelFactory.model_for(assoc.target_resource)
    join_sql = build_jsonb_join_sql(current_class, assoc, target_model)
    joins << join_sql
    
    current_class = target_model
  end
  
  joins
end
```

**PostgreSQL JSONB Join Strategy**:

Since all data is in `open_resource_entities`, we need to self-join:

```sql
-- Find posts where author.name = 'John'
SELECT posts.* FROM open_resource_entities posts
JOIN open_resource_entities authors ON 
  authors.resource_id = (SELECT id FROM open_resource_resources WHERE name = 'author')
  AND (posts.properties->>'author_id')::bigint = authors.id
WHERE 
  posts.resource_id = (SELECT id FROM open_resource_resources WHERE name = 'post')
  AND authors.properties->>'name' = 'John'
```

### Phase 4: Association Metadata

**Migration additions**:

```ruby
add_column :open_resource_resource_associations, :polymorphic, :boolean, default: false
add_column :open_resource_resource_associations, :dependent, :string  # :destroy, :nullify
add_column :open_resource_resource_associations, :conditions, :jsonb, default: {}
add_column :open_resource_resource_associations, :through_resource_id, :bigint  # For has_many :through
```

**Polymorphic associations**:

```yaml
associations:
  - type: belongs_to
    name: commentable
    polymorphic: true  # Stores commentable_id + commentable_type in JSONB
```

**Filtered associations**:

```yaml
associations:
  - type: has_many
    name: published_posts
    target: post
    conditions:
      status: "published"
```

## Implementation Priority

### Must Have (Phase 1)
1. ✅ Return ActiveRecord::Relation from associations
2. ✅ Fix has_many to not call `.to_a`

### Should Have (Phase 2)
3. Auto-create inverse associations from `inverse_of`
4. Add `dependent` support for cascade deletes

### Nice to Have (Phase 3-4)
5. Deep filtering through associations (complex)
6. Sorting through associations
7. Polymorphic associations
8. Has many :through
9. Filtered associations with conditions

## Recommended Starting Point

Let's implement **Phase 1** immediately - it's a one-line fix that enables powerful chaining:

```ruby
# In dynamic_model_factory.rb, line 175-176:
# REMOVE: .to_a
# KEEP: Returns ActiveRecord::Relation
```

Then we can discuss which Phase 2+ features are most important for your use case.
