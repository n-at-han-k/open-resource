# frozen_string_literal: true

require "graphql"

module OpenResource
  # Dynamically builds a GraphQL schema from Resource / ResourceAttribute /
  # ResourceAssociation metadata.  Mirrors the two-phase approach used by
  # DynamicModelFactory: first build all object types with scalar fields,
  # then wire association fields once every type exists.
  module GraphqlSchemaFactory
    # Namespace for dynamically generated GraphQL types.
    module Types; end

    # ── Scalar-type mapping ───────────────────────────────────────────────
    GRAPHQL_TYPE_MAP = {
      "string"   => GraphQL::Types::String,
      "text"     => GraphQL::Types::String,
      "select"   => GraphQL::Types::String,
      "email"    => GraphQL::Types::String,
      "url"      => GraphQL::Types::String,
      "phone"    => GraphQL::Types::String,
      "integer"  => GraphQL::Types::Int,
      "float"    => GraphQL::Types::Float,
      "boolean"  => GraphQL::Types::Boolean,
      "date"     => GraphQL::Types::ISO8601Date,
      "datetime" => GraphQL::Types::ISO8601DateTime
    }.freeze

    class << self
      # Returns the cached schema, building it on first access.
      def schema
        @schema || build_all
      end

      # Builds (or rebuilds) the complete GraphQL schema from the current
      # Resource / ResourceAttribute / ResourceAssociation records.
      def build_all
        clear_all
        types = {}

        # Phase 1 — object types with scalar fields only
        Resource.includes(:resource_attributes).find_each do |resource|
          types[resource.name] = build_object_type(resource)
        end

        # Phase 2 — wire association fields (all types exist now)
        wire_association_fields(types)

        # Build connection types for paginated lists
        connections = build_connection_types(types)

        # Build query + mutation root types
        query_type    = build_query_type(types, connections)
        mutation_type = build_mutation_type(types)

        @schema = Class.new(GraphQL::Schema) do
          query query_type
          mutation mutation_type if mutation_type
        end
      end

      # Drop the cached schema so the next call to `schema` rebuilds it.
      def rebuild
        @schema = nil
        build_all
      end

      private

      # Remove all previously generated type constants.
      def clear_all
        @schema = nil
        Types.constants.each { |c| Types.send(:remove_const, c) }
      end

      # ── Phase 1: Object types ────────────────────────────────────────────

      def build_object_type(resource)
        factory = self
        attrs   = resource.resource_attributes.to_a

        type = Class.new(GraphQL::Schema::Object) do
          graphql_name resource.name.classify
          description  resource.description.presence || "#{resource.display_label} resource"

          field :id,         GraphQL::Types::ID,                null: false
          field :created_at, GraphQL::Types::ISO8601DateTime,   null: false
          field :updated_at, GraphQL::Types::ISO8601DateTime,   null: false

          attrs.each do |attr_def|
            gql_type = factory.send(:graphql_type_for, attr_def.field_type)
            field attr_def.name, gql_type, null: !attr_def.required,
                  description: attr_def.display_label

            # Resolver: read from JSONB properties via the dynamic model accessor.
            define_method(attr_def.name) { object.send(attr_def.name) }
          end
        end

        const_name = resource.name.classify
        Types.const_set(const_name, type) if !Types.const_defined?(const_name, false)
        type
      end

      # ── Phase 2: Association fields ──────────────────────────────────────

      def wire_association_fields(types)
        ResourceAssociation.all.each do |assoc|
          child_type  = types[assoc.child]
          parent_type = types[assoc.parent]
          next unless child_type && parent_type

          # belongs_to on the child type → singular parent
          add_belongs_to_field(child_type, assoc, parent_type)

          # has_many / has_one on the parent type → child(ren)
          add_has_many_or_one_field(parent_type, assoc, child_type)
        end
      end

      def add_belongs_to_field(child_type, assoc, parent_type)
        method_name = assoc.belongs_to_name
        fk_name     = assoc.foreign_key_name

        # FK scalar field (e.g., author_id: Int)
        child_type.field fk_name, GraphQL::Types::Int, null: true,
                         description: "Foreign key for #{method_name}"
        child_type.define_method(fk_name) { object.read_property(fk_name)&.to_i }

        # Association field (e.g., author: Author)
        child_type.field method_name, parent_type, null: true,
                         description: "Associated #{assoc.parent}"
        child_type.define_method(method_name) { object.send(method_name) }
      end

      def add_has_many_or_one_field(parent_type, assoc, child_type)
        method_name = assoc.has_many_name

        if assoc.has_many?
          parent_type.field method_name, [ child_type ], null: false,
                           description: "Associated #{assoc.child.pluralize}"
          parent_type.define_method(method_name) { object.send(method_name).to_a }
        else
          parent_type.field method_name, child_type, null: true,
                           description: "Associated #{assoc.child.singularize}"
          parent_type.define_method(method_name) { object.send(method_name)&.first }
        end
      end

      # ── Connection types (pagination wrappers) ──────────────────────────

      def build_connection_types(types)
        types.transform_values do |obj_type|
          name = obj_type.graphql_name
          node_type = obj_type

          Class.new(GraphQL::Schema::Object) do
            graphql_name "#{name}Connection"
            description  "Paginated list of #{name} records"

            field :nodes,        [ node_type ], null: false, description: "List of records"
            field :current_page, GraphQL::Types::Int, null: false
            field :total_pages,  GraphQL::Types::Int, null: false
            field :total_count,  GraphQL::Types::Int, null: false
          end
        end
      end

      # ── Query type ──────────────────────────────────────────────────────

      def build_query_type(types, connections)
        factory = self

        Class.new(GraphQL::Schema::Object) do
          graphql_name "Query"
          description  "Auto-generated queries for all OpenResource resources"

          Resource.find_each do |resource|
            obj_type = types[resource.name]
            conn_type = connections[resource.name]
            next unless obj_type && conn_type

            res_name = resource.name

            # Singular: post(id: ID!): Post
            field res_name.singularize, obj_type, null: true,
                  description: "Find a #{resource.display_label} by ID" do
              argument :id, GraphQL::Types::ID, required: true
            end

            define_method(res_name.singularize) do |id:|
              r = OpenResource::Resource.find_by(name: res_name)
              return nil unless r

              model = DynamicModelFactory.model_for(r)
              model.find_by(id: id)
            end

            # Plural: posts(page: Int, perPage: Int): PostConnection!
            field res_name.pluralize, conn_type, null: false,
                  description: "List #{resource.display_label.pluralize} with pagination" do
              argument :page,     GraphQL::Types::Int, required: false, default_value: 1
              argument :per_page, GraphQL::Types::Int, required: false, default_value: 25
            end

            define_method(res_name.pluralize) do |page: 1, per_page: 25|
              r = OpenResource::Resource.find_by(name: res_name)
              return { nodes: [], current_page: 1, total_pages: 0, total_count: 0 } unless r

              model   = DynamicModelFactory.model_for(r)
              results = model.page(page).per(per_page)

              {
                nodes:        results.to_a,
                current_page: results.current_page,
                total_pages:  results.total_pages,
                total_count:  results.total_count
              }
            end
          end
        end
      end

      # ── Mutation type ───────────────────────────────────────────────────

      def build_mutation_type(types)
        factory = self
        mutations_added = false

        mutation_type = Class.new(GraphQL::Schema::Object) do
          graphql_name "Mutation"
          description  "Auto-generated mutations for all OpenResource resources"

          Resource.includes(:resource_attributes).find_each do |resource|
            obj_type = types[resource.name]
            next unless obj_type

            res_name    = resource.name
            attrs       = resource.resource_attributes.to_a
            fk_names    = resource.child_associations.map(&:foreign_key_name)
            create_input = factory.send(:build_input_type, resource, attrs, fk_names, :create)
            update_input = factory.send(:build_input_type, resource, attrs, fk_names, :update)

            mutations_added = true

            # createPost(input: CreatePostInput!): Post!
            field "create_#{res_name.singularize}", obj_type, null: false,
                  description: "Create a new #{resource.display_label}" do
              argument :input, create_input, required: true
            end

            define_method("create_#{res_name.singularize}") do |input:|
              r = OpenResource::Resource.find_by(name: res_name)
              raise GraphQL::ExecutionError, "Unknown resource" unless r

              model  = DynamicModelFactory.model_for(r)
              entity = model.new
              entity.assign_properties(input.to_h.stringify_keys)
              entity.save!
              entity
            rescue ActiveRecord::RecordInvalid => e
              raise GraphQL::ExecutionError, e.record.errors.full_messages.join(", ")
            end

            # updatePost(id: ID!, input: UpdatePostInput!): Post!
            field "update_#{res_name.singularize}", obj_type, null: false,
                  description: "Update an existing #{resource.display_label}" do
              argument :id,    GraphQL::Types::ID, required: true
              argument :input, update_input, required: true
            end

            define_method("update_#{res_name.singularize}") do |id:, input:|
              r = OpenResource::Resource.find_by(name: res_name)
              raise GraphQL::ExecutionError, "Unknown resource" unless r

              model  = DynamicModelFactory.model_for(r)
              entity = model.find(id)
              entity.assign_properties(input.to_h.compact.stringify_keys)
              entity.save!
              entity
            rescue ActiveRecord::RecordNotFound
              raise GraphQL::ExecutionError, "#{resource.display_label} not found"
            rescue ActiveRecord::RecordInvalid => e
              raise GraphQL::ExecutionError, e.record.errors.full_messages.join(", ")
            end

            # deletePost(id: ID!): Boolean!
            field "delete_#{res_name.singularize}", GraphQL::Types::Boolean, null: false,
                  description: "Delete a #{resource.display_label}" do
              argument :id, GraphQL::Types::ID, required: true
            end

            define_method("delete_#{res_name.singularize}") do |id:|
              r = OpenResource::Resource.find_by(name: res_name)
              raise GraphQL::ExecutionError, "Unknown resource" unless r

              model = DynamicModelFactory.model_for(r)
              model.find(id).destroy!
              true
            rescue ActiveRecord::RecordNotFound
              raise GraphQL::ExecutionError, "#{resource.display_label} not found"
            end
          end
        end

        mutations_added ? mutation_type : nil
      end

      # ── Input types ─────────────────────────────────────────────────────

      def build_input_type(resource, attrs, fk_names, mode)
        factory = self
        prefix  = mode == :create ? "Create" : "Update"
        is_create = mode == :create

        input = Class.new(GraphQL::Schema::InputObject) do
          graphql_name "#{prefix}#{resource.name.classify}Input"
          description  "Input for #{prefix.downcase}ing a #{resource.display_label}"

          attrs.each do |attr_def|
            gql_type = factory.send(:graphql_type_for, attr_def.field_type)
            # On create, required fields are required; on update, everything is optional.
            required = is_create && attr_def.required
            argument attr_def.name, gql_type, required: required
          end

          fk_names.each do |fk|
            argument fk, GraphQL::Types::Int, required: false,
                     description: "Foreign key: #{fk}"
          end
        end

        const_name = "#{prefix}#{resource.name.classify}Input"
        Types.const_set(const_name, input) if !Types.const_defined?(const_name, false)
        input
      end

      # ── Helpers ─────────────────────────────────────────────────────────

      def graphql_type_for(field_type)
        GRAPHQL_TYPE_MAP.fetch(field_type, GraphQL::Types::String)
      end
    end
  end
end
