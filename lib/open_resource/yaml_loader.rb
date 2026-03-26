# frozen_string_literal: true

require "yaml"

module OpenResource
  # Loads resource definitions from YAML config files into the database.
  #
  # YAML is the foundational source of truth for resource and attribute definitions.
  # Associations are managed separately via the database (not YAML).
  #
  # Expected file location: config/resources/*.yml in the host Rails app.
  module YamlLoader
    class << self
      # Loads all YAML resource files and syncs them to the database.
      def load_all
        config_path = resource_config_path
        return unless config_path.exist?

        Dir[config_path.join("*.yml")].sort.each do |file|
          load_file(file)
        end
      end

      # Loads a single YAML file and syncs it to the database.
      def load_file(path)
        data = YAML.safe_load_file(path, permitted_classes: [Symbol])
        return if data.blank?

        sync_resource(data)
      rescue => e
        Rails.logger.error "[OpenResource] Failed to load #{path}: #{e.message}"
        raise e unless Rails.env.production?
      end

      private

      def resource_config_path
        Rails.root.join("config", "resources")
      end

      def sync_resource(data)
        name = data.fetch("name")

        resource = Resource.find_or_initialize_by(name: name)

        resource.assign_attributes(
          label: data["label"],
          description: data["description"],
          icon: data.dig("menu", "icon") || data["icon"],
          menu_parent: data.dig("menu", "parent"),
          menu_priority: data.dig("menu", "priority") || 10,
          menu_label: data.dig("menu", "label"),
          sort_order: data["sort_order"] || "created_at_desc",
          per_page: data["per_page"] || 25,
          actions: data["actions"] || %w[index show new edit destroy],
          yaml_managed: true
        )
        resource.save!

        sync_attributes(resource, data["attributes"] || [])

        resource
      end

      def sync_attributes(resource, attrs_data)
        attrs_data.each_with_index do |attr_data, index|
          attr_name = attr_data.fetch("name")

          attr = resource.resource_attributes.find_or_initialize_by(name: attr_name)
          attr.assign_attributes(
            label: attr_data["label"],
            field_type: attr_data["type"] || "string",
            required: attr_data["required"] || false,
            default_value: attr_data["default"]&.to_s,
            position: attr_data["position"] || index,
            filterable: attr_data.fetch("filterable", true),
            sortable: attr_data.fetch("sortable", true),
            index_visible: attr_data.fetch("index_visible", true),
            show_visible: attr_data.fetch("show_visible", true),
            form_visible: attr_data.fetch("form_visible", true),
            input_options: attr_data["input_options"] || {},
            validations: attr_data["validations"] || {},
            yaml_managed: true
          )
          attr.save!
        end
      end
    end
  end
end
