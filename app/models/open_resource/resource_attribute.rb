# frozen_string_literal: true

module OpenResource
  class ResourceAttribute < ApplicationRecord
    self.table_name = "open_resource_resource_attributes"

    FIELD_TYPES = %w[
      string text integer float boolean
      date datetime select
      email url phone
    ].freeze

    belongs_to :resource, class_name: "OpenResource::Resource", inverse_of: :resource_attributes

    validates :name, presence: true,
                     uniqueness: { scope: :resource_id },
                     format: { with: /\A[a-z][a-z0-9_]*\z/, message: "must be lowercase snake_case" }
    validates :field_type, presence: true, inclusion: { in: FIELD_TYPES }

    # Returns the human-readable label, falling back to a titleized name.
    def display_label
      label.presence || name.titleize
    end

    # Returns the ActiveAdmin input type for this attribute.
    def input_type
      case field_type
      when "string"   then :string
      when "text"     then :text
      when "integer"  then :number
      when "float"    then :number
      when "boolean"  then :boolean
      when "date"     then :datepicker
      when "datetime" then :datepicker
      when "select"   then :select
      when "email"    then :email
      when "url"      then :url
      when "phone"    then :phone
      else :string
      end
    end

    # Casts a string value to the appropriate Ruby type.
    def cast_value(value)
      return nil if value.nil?

      case field_type
      when "integer"  then value.to_i
      when "float"    then value.to_f
      when "boolean"  then ActiveModel::Type::Boolean.new.cast(value)
      when "date"     then value.is_a?(String) ? Date.parse(value) : value
      when "datetime" then value.is_a?(String) ? Time.zone.parse(value) : value
      else value.to_s
      end
    rescue ArgumentError, TypeError
      value
    end

    def to_s
      display_label
    end

    # Ransack allowlisting
    def self.ransackable_attributes(auth_object = nil)
      %w[name label field_type required position resource_id created_at updated_at]
    end

    def self.ransackable_associations(auth_object = nil)
      %w[resource]
    end
  end
end
