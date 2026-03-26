# frozen_string_literal: true

module OpenResource
  class Entity < ApplicationRecord
    self.table_name = "open_resource_entities"

    belongs_to :resource, class_name: "OpenResource::Resource", inverse_of: :entities

    # Read a property from the JSONB column.
    def read_property(key)
      properties&.fetch(key.to_s, nil)
    end

    # Write a property to the JSONB column.
    def write_property(key, value)
      self.properties = (properties || {}).merge(key.to_s => value)
    end

    # Bulk-assign properties from a hash, merging with existing.
    def assign_properties(attrs)
      attrs.each { |k, v| write_property(k, v) }
    end

    # Returns a display name for this entity, trying common name fields.
    def display_name
      %w[name title label email].each do |field|
        val = read_property(field)
        return val if val.present?
      end
      "#{resource&.display_label} ##{id}"
    end

    alias_method :to_s, :display_name

    # Ransack allowlisting -- dynamic attributes are handled by the dynamic model subclass.
    def self.ransackable_attributes(auth_object = nil)
      %w[id resource_id properties created_at updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[resource]
    end
  end
end
