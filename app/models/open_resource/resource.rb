# frozen_string_literal: true

module OpenResource
  class Resource < ApplicationRecord
    self.table_name = "open_resource_resources"

    has_many :resource_attributes, -> { order(position: :asc) },
             class_name: "OpenResource::ResourceAttribute",
             dependent: :destroy,
             inverse_of: :resource

    has_many :entities,
             class_name: "OpenResource::Entity",
             dependent: :destroy,
             inverse_of: :resource

    validates :name, presence: true,
                     uniqueness: true,
                     format: { with: /\A[a-z][a-z0-9_]*\z/, message: "must be lowercase snake_case" }

    accepts_nested_attributes_for :resource_attributes, allow_destroy: true

    # Associations where this resource is the child (belongs_to side).
    def child_associations
      ResourceAssociation.where(child: name)
    end

    # Associations where this resource is the parent (has_many/has_one side).
    def parent_associations
      ResourceAssociation.where(parent: name)
    end

    # All associations involving this resource.
    def associations
      ResourceAssociation.where("child = ? OR parent = ?", name, name)
    end

    # Returns the human-readable label, falling back to a titleized name.
    def display_label
      label.presence || name.titleize
    end

    # Returns the list of permitted actions for this resource.
    def permitted_actions
      (actions.presence || %w[index show new edit destroy]).map(&:to_sym)
    end

    # Returns the dynamic model class for this resource, building it if needed.
    def dynamic_model_class
      DynamicModelFactory.model_for(self)
    end

    def to_s
      display_label
    end

    # Ransack allowlisting
    def self.ransackable_attributes(auth_object = nil)
      %w[name label description created_at updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[resource_attributes entities]
    end
  end
end
