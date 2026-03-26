# frozen_string_literal: true

module OpenResource
  class ResourceAssociation < ApplicationRecord
    self.table_name = "open_resource_resource_associations"

    validates :child, presence: true
    validates :parent, presence: true
    validate :child_resource_exists
    validate :parent_resource_exists

    # Derived method name for the belongs_to side (on the child resource).
    # e.g., child="post", parent="author" → post.author
    def belongs_to_name
      name.presence || parent.singularize
    end

    # Derived method name for the has_many/has_one side (on the parent resource).
    # e.g., child="post", parent="author" → author.posts
    def has_many_name
      has_many? ? child.pluralize : child.singularize
    end

    # FK key stored in the child's JSONB properties.
    # e.g., name="writer" → "writer_id", or default → "author_id"
    def foreign_key_name
      "#{belongs_to_name}_id"
    end

    def to_s
      if has_many?
        "#{child}.belongs_to :#{belongs_to_name} / #{parent}.has_many :#{has_many_name}"
      else
        "#{child}.belongs_to :#{belongs_to_name} / #{parent}.has_one :#{has_many_name}"
      end
    end

    def self.ransackable_attributes(auth_object = nil)
      %w[child parent has_many name created_at updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end

    private

    def child_resource_exists
      return if child.blank?

      unless Resource.exists?(name: child)
        errors.add(:child, "resource '#{child}' does not exist")
      end
    end

    def parent_resource_exists
      return if parent.blank?

      unless Resource.exists?(name: parent)
        errors.add(:parent, "resource '#{parent}' does not exist")
      end
    end
  end
end
