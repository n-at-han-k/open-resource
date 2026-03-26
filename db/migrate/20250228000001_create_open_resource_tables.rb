# frozen_string_literal: true

class CreateOpenResourceTables < ActiveRecord::Migration[8.1]
  def change
    # Resource type definitions (e.g., "post", "author", "tag")
    create_table :open_resource_resources do |t|
      t.string :name, null: false
      t.string :label
      t.text :description
      t.string :icon
      t.string :menu_parent
      t.integer :menu_priority, default: 10
      t.string :menu_label
      t.string :sort_order, default: "created_at_desc"
      t.integer :per_page, default: 25
      t.jsonb :actions, default: %w[index show new edit destroy]
      t.boolean :yaml_managed, default: false, null: false
      t.timestamps
    end

    add_index :open_resource_resources, :name, unique: true

    # Field definitions per resource (name, type, validations)
    create_table :open_resource_resource_attributes do |t|
      t.references :resource, null: false, foreign_key: { to_table: :open_resource_resources }
      t.string :name, null: false
      t.string :label
      t.string :field_type, null: false, default: "string"
      t.boolean :required, default: false, null: false
      t.string :default_value
      t.integer :position, default: 0, null: false
      t.boolean :filterable, default: true, null: false
      t.boolean :sortable, default: true, null: false
      t.boolean :index_visible, default: true, null: false
      t.boolean :show_visible, default: true, null: false
      t.boolean :form_visible, default: true, null: false
      t.jsonb :input_options, default: {}
      t.jsonb :validations, default: {}
      t.boolean :yaml_managed, default: false, null: false
      t.timestamps
    end

    add_index :open_resource_resource_attributes, %i[resource_id name], unique: true,
              name: "idx_or_res_attrs_on_resource_id_and_name"
    add_index :open_resource_resource_attributes, %i[resource_id position],
              name: "idx_or_res_attrs_on_resource_id_and_position"

    # Associations between resources
    # child  = belongs_to side (holds FK in JSONB)
    # parent = has_many/has_one side
    # has_many: true = has_many, false = has_one
    # name: optional override for method/FK name
    create_table :open_resource_resource_associations do |t|
      t.string :child, null: false
      t.string :parent, null: false
      t.boolean :has_many, default: true, null: false
      t.string :name
      t.timestamps
    end

    add_index :open_resource_resource_associations, %i[child parent],
              name: "idx_or_assocs_on_child_and_parent"
    add_index :open_resource_resource_associations, :child,
              name: "idx_or_assocs_on_child"
    add_index :open_resource_resource_associations, :parent,
              name: "idx_or_assocs_on_parent"

    # All entity data with JSONB properties
    create_table :open_resource_entities do |t|
      t.references :resource, null: false, foreign_key: { to_table: :open_resource_resources }
      t.jsonb :properties, default: {}, null: false
      t.timestamps
    end

    add_index :open_resource_entities, :properties, using: :gin
  end
end
