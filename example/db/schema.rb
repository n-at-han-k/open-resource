# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_02_28_000001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "open_resource_entities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "properties", default: {}, null: false
    t.bigint "resource_id", null: false
    t.datetime "updated_at", null: false
    t.index ["properties"], name: "index_open_resource_entities_on_properties", using: :gin
    t.index ["resource_id"], name: "index_open_resource_entities_on_resource_id"
  end

  create_table "open_resource_resource_associations", force: :cascade do |t|
    t.string "child", null: false
    t.datetime "created_at", null: false
    t.boolean "has_many", default: true, null: false
    t.string "name"
    t.string "parent", null: false
    t.datetime "updated_at", null: false
    t.index ["child", "parent"], name: "idx_or_assocs_on_child_and_parent"
    t.index ["child"], name: "idx_or_assocs_on_child"
    t.index ["parent"], name: "idx_or_assocs_on_parent"
  end

  create_table "open_resource_resource_attributes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "default_value"
    t.string "field_type", default: "string", null: false
    t.boolean "filterable", default: true, null: false
    t.boolean "form_visible", default: true, null: false
    t.boolean "index_visible", default: true, null: false
    t.jsonb "input_options", default: {}
    t.string "label"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.boolean "required", default: false, null: false
    t.bigint "resource_id", null: false
    t.boolean "show_visible", default: true, null: false
    t.boolean "sortable", default: true, null: false
    t.datetime "updated_at", null: false
    t.jsonb "validations", default: {}
    t.boolean "yaml_managed", default: false, null: false
    t.index ["resource_id", "name"], name: "idx_or_res_attrs_on_resource_id_and_name", unique: true
    t.index ["resource_id", "position"], name: "idx_or_res_attrs_on_resource_id_and_position"
    t.index ["resource_id"], name: "index_open_resource_resource_attributes_on_resource_id"
  end

  create_table "open_resource_resources", force: :cascade do |t|
    t.jsonb "actions", default: ["index", "show", "new", "edit", "destroy"]
    t.datetime "created_at", null: false
    t.text "description"
    t.string "icon"
    t.string "label"
    t.string "menu_label"
    t.string "menu_parent"
    t.integer "menu_priority", default: 10
    t.string "name", null: false
    t.integer "per_page", default: 25
    t.string "sort_order", default: "created_at_desc"
    t.datetime "updated_at", null: false
    t.boolean "yaml_managed", default: false, null: false
    t.index ["name"], name: "index_open_resource_resources_on_name", unique: true
  end

  add_foreign_key "open_resource_entities", "open_resource_resources", column: "resource_id"
  add_foreign_key "open_resource_resource_attributes", "open_resource_resources", column: "resource_id"
end
