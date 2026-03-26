# Open Resource

A bare minimum, zero-feature, dynamic resource creation framework for Rails.

## What It Does

Connects to your database, inspects tables at runtime, generates ActiveRecord models, and exposes them via REST API. That's it.

- **No queries** - Just CRUD
- **No dashboards** - Use the API
- **No config persistence** - Pure introspection
- **No users/roles** - Use host app auth
- **No UI** - Just JSON

## Usage

Add to your Gemfile:

```ruby
gem 'open_resource', path: '../open_resource'
```

Mount in routes:

```ruby
mount OpenResource::Engine => "/api"
```

Now visit:

- `GET /api/schema` - List all tables as JSON
- `GET /api/data/customers` - List customers
- `GET /api/data/customers/123` - Get one customer
- `POST /api/data/customers` - Create customer
- `PATCH /api/data/customers/123` - Update customer
- `DELETE /api/data/customers/123` - Delete customer

## How It Works

1. At boot, `DefineArModels` scans all database tables
2. Creates a `Class.new(ResourceRecord)` for each table
3. Auto-detects primary keys and foreign key relationships
4. Registers them as Ruby constants
5. Dynamic routes map `/data/:table_name` to CRUD actions

That's ~80 lines of code vs Motor's ~2000.

## Generated Schema Format

```json
[
  {
    "name": "customers",
    "class_name": "Customer",
    "primary_key": "id",
    "columns": [
      {"name": "id", "type": "integer", "null": false},
      {"name": "name", "type": "string", "null": false},
      {"name": "email", "type": "string", "null": true}
    ],
    "associations": ["orders"]
  }
]
```
