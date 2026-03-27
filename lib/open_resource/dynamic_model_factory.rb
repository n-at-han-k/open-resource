# frozen_string_literal: true

module OpenResource
  # Builds dynamic ActiveRecord model classes for each Resource definition.
  #
  # Each resource gets a class like OpenResource::DynamicModels::Post that:
  # - Inherits from OpenResource::Entity
  # - Is scoped to the resource's entities via default_scope
  # - Has attribute accessors for each ResourceAttribute (reading/writing JSONB properties)
  # - Has association methods derived from ResourceAssociation records
  module DynamicModelFactory
    # Module namespace for all dynamically created model classes.
    module DynamicModels; end

    class << self
      # Returns the dynamic model class for a given Resource, creating it if needed.
      def model_for(resource)
        class_name = resource.name.classify
        if DynamicModels.const_defined?(class_name, false)
          DynamicModels.const_get(class_name, false)
        else
          build_model(resource)
        end
      end

      # Builds all dynamic models for every Resource in the database.
      def build_all
        clear_all

        # Phase 1: Build all models (attributes only, no associations yet)
        Resource.includes(:resource_attributes).find_each do |resource|
          build_model(resource)
        end

        # Phase 2: Wire up associations (all models exist now)
        wire_associations
      end

      # Removes all dynamically created model constants.
      def clear_all
        DynamicModels.constants.each do |const|
          DynamicModels.send(:remove_const, const)
        end
      end

      # Rebuilds a single resource's dynamic model (e.g., after attribute changes).
      def rebuild(resource)
        class_name = resource.name.classify
        DynamicModels.send(:remove_const, class_name) if DynamicModels.const_defined?(class_name, false)
        build_model(resource.reload)
        wire_associations
      end

      private

      def build_model(resource)
        class_name = resource.name.classify
        resource_id = resource.id
        attributes = resource.resource_attributes.to_a

        klass = Class.new(Entity) do
          self.table_name = "open_resource_entities"

          # Scope to only this resource's entities and auto-set resource_id on new records.
          default_scope { where(resource_id: resource_id) }

          after_initialize do |entity|
            entity.resource_id = resource_id if entity.new_record? && entity.resource_id.nil?
          end

          # Define attribute accessors for each ResourceAttribute.
          attributes.each do |attr_def|
            attr_name = attr_def.name

            define_method(attr_name) do
              val = read_property(attr_name)
              attr_def.cast_value(val)
            end

            define_method(:"#{attr_name}=") do |value|
              write_property(attr_name, value)
            end
          end

          # Bulk property assignment support.
          define_method(:assign_attributes) do |new_attributes|
            dynamic_attrs = {}
            static_attrs = {}

            attr_names = attributes.map(&:name)
            new_attributes.each do |key, value|
              if attr_names.include?(key.to_s)
                dynamic_attrs[key.to_s] = value
              else
                static_attrs[key] = value
              end
            end

            super(static_attrs) unless static_attrs.empty?
            assign_properties(dynamic_attrs) unless dynamic_attrs.empty?
          end

          # Display name.
          define_method(:display_name) do
            name_attrs = attributes.select { |a| %w[name title label].include?(a.name) }
            name_attrs.each do |a|
              val = read_property(a.name)
              return val if val.present?
            end
            "#{resource.display_label} ##{id}"
          end

          # Ransack support.
          # Include `properties` to enable JSONB prefix search (e.g. properties_name_cont).
          define_singleton_method(:ransackable_attributes) do |auth_object = nil|
            %w[id resource_id properties created_at updated_at] + attributes.select(&:filterable).map(&:name)
          end

          define_singleton_method(:ransackable_associations) do |auth_object = nil|
            []
          end
        end

        DynamicModels.const_set(class_name, klass)
        klass
      end

      # Wire up all associations after all models are built.
      # Reads ResourceAssociation records and defines methods on the appropriate classes.
      def wire_associations
        all_assocs = ResourceAssociation.all.to_a

        # Group by child to detect polymorphic and M2M
        by_child = all_assocs.group_by(&:child)

        all_assocs.each do |assoc|
          child_resource = Resource.find_by(name: assoc.child)
          parent_resource = Resource.find_by(name: assoc.parent)
          next unless child_resource && parent_resource

          child_class = model_for(child_resource)
          parent_class = model_for(parent_resource)

          # Detect polymorphic: same child + same derived name, multiple parents
          same_name_assocs = all_assocs.select { |a|
            a.child == assoc.child && a.belongs_to_name == assoc.belongs_to_name
          }
          is_polymorphic = same_name_assocs.size > 1

          # Define belongs_to on child
          define_belongs_to(child_class, assoc, parent_resource, is_polymorphic)

          # Define has_many/has_one on parent
          define_has_many_or_one(parent_class, assoc, child_resource, is_polymorphic)
        end

        # Detect M2M: resources that are child in exactly 2+ associations with no name override
        detect_and_wire_m2m(all_assocs, by_child)
      end

      # Define belongs_to method + FK accessors on the child class.
      def define_belongs_to(child_class, assoc, parent_resource, is_polymorphic)
        method_name = assoc.belongs_to_name
        fk = assoc.foreign_key_name
        parent_rid = parent_resource.id
        parent_name = assoc.parent

        if is_polymorphic
          # Polymorphic: reads {name}_type + {name}_id from JSONB
          type_key = "#{method_name}_type"

          child_class.define_method(method_name) do
            target_type = read_property(type_key)
            target_id = read_property(fk)
            return nil if target_type.blank? || target_id.blank?

            target_resource = OpenResource::Resource.find_by(name: target_type)
            return nil unless target_resource

            target_model = DynamicModelFactory.model_for(target_resource)
            target_model.unscoped.find_by(id: target_id, resource_id: target_resource.id)
          end

          child_class.define_method(:"#{method_name}=") do |entity|
            if entity.nil?
              write_property(fk, nil)
              write_property(type_key, nil)
            else
              write_property(fk, entity.id)
              write_property(type_key, entity.resource.name)
            end
          end
        else
          # Standard belongs_to
          child_class.define_method(method_name) do
            target_id = read_property(fk)
            return nil if target_id.blank?

            target_model = DynamicModelFactory.model_for(parent_resource)
            target_model.unscoped.find_by(id: target_id, resource_id: parent_rid)
          end

          child_class.define_method(:"#{method_name}=") do |entity|
            write_property(fk, entity&.id)
          end
        end

        # FK accessors (always defined)
        child_class.define_method(fk) do
          read_property(fk)
        end

        child_class.define_method(:"#{fk}=") do |value|
          write_property(fk, value.presence&.to_i)
        end
      end

      # Define has_many or has_one method on the parent class.
      def define_has_many_or_one(parent_class, assoc, child_resource, is_polymorphic)
        method_name = assoc.has_many_name
        fk = assoc.foreign_key_name
        child_rid = child_resource.id

        if is_polymorphic
          # Polymorphic has_many: filter by both FK and type
          type_key = "#{assoc.belongs_to_name}_type"
          parent_name = assoc.parent

          parent_class.define_method(method_name) do
            child_model = DynamicModelFactory.model_for(child_resource)
            child_model.unscoped.where(resource_id: child_rid)
                       .where("properties @> ?", { fk => id, type_key => parent_name }.to_json)
          end
        elsif assoc.has_many?
          # Standard has_many: returns ActiveRecord::Relation
          parent_class.define_method(method_name) do
            child_model = DynamicModelFactory.model_for(child_resource)
            child_model.unscoped.where(resource_id: child_rid)
                       .where("properties @> ?", { fk => id }.to_json)
          end
        else
          # has_one: returns Relation limited to 1
          parent_class.define_method(method_name) do
            child_model = DynamicModelFactory.model_for(child_resource)
            child_model.unscoped.where(resource_id: child_rid)
                       .where("properties @> ?", { fk => id }.to_json)
                       .limit(1)
          end
        end
      end

      # Detect M2M pattern: a resource that is child in 2+ associations (join table).
      # Creates has_many :through style methods on both parent resources.
      def detect_and_wire_m2m(all_assocs, by_child)
        by_child.each do |join_resource_name, assocs|
          # A join table candidate: child in 2+ associations, no name overrides
          next unless assocs.size >= 2
          next if assocs.any? { |a| a.name.present? }

          join_resource = Resource.find_by(name: join_resource_name)
          next unless join_resource

          join_rid = join_resource.id

          # For each pair of parents, create M2M methods
          assocs.combination(2).each do |assoc_a, assoc_b|
            parent_a_resource = Resource.find_by(name: assoc_a.parent)
            parent_b_resource = Resource.find_by(name: assoc_b.parent)
            next unless parent_a_resource && parent_b_resource

            parent_a_class = model_for(parent_a_resource)
            parent_b_class = model_for(parent_b_resource)

            fk_a = assoc_a.foreign_key_name  # e.g., "post_id"
            fk_b = assoc_b.foreign_key_name  # e.g., "tag_id"
            parent_b_rid = parent_b_resource.id
            parent_a_rid = parent_a_resource.id

            # On Parent A: has_many Parent B through join
            # e.g., post.tags
            m2m_name_on_a = assoc_b.parent.pluralize
            parent_a_class.define_method(m2m_name_on_a) do
              OpenResource::Entity
                .where(resource_id: parent_b_rid)
                .where(
                  "id IN (SELECT (properties->>'#{fk_b}')::bigint " \
                  "FROM open_resource_entities " \
                  "WHERE resource_id = ? AND properties @> ?)",
                  join_rid, { fk_a => id }.to_json
                )
            end

            # On Parent B: has_many Parent A through join
            # e.g., tag.posts
            m2m_name_on_b = assoc_a.parent.pluralize
            parent_b_class.define_method(m2m_name_on_b) do
              OpenResource::Entity
                .where(resource_id: parent_a_rid)
                .where(
                  "id IN (SELECT (properties->>'#{fk_a}')::bigint " \
                  "FROM open_resource_entities " \
                  "WHERE resource_id = ? AND properties @> ?)",
                  join_rid, { fk_b => id }.to_json
                )
            end
          end
        end
      end
    end
  end
end
