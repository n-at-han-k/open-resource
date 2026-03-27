# frozen_string_literal: true

module OpenResource
  module Api
    class SchemaController < ApplicationController
      def index
        resources = Resource.all.map { |r| serialize_resource(r) }
        render json: resources
      end

      def show
        resource = Resource.find_by(name: params[:resource])

        if resource.nil?
          render json: { error: "Resource not found" }, status: :not_found
          return
        end

        render json: serialize_resource(resource)
      end

      private

      def serialize_resource(resource)
        {
          name: resource.name,
          label: resource.display_label,
          description: resource.description,
          attributes: resource.resource_attributes.map { |attr|
            {
              name: attr.name,
              label: attr.display_label,
              type: attr.field_type,
              required: attr.required
            }
          },
          associations: serialize_associations(resource)
        }
      end

      def serialize_associations(resource)
        child_assocs = ResourceAssociation.where(child: resource.name).map { |a|
          { role: "belongs_to", name: a.belongs_to_name, target: a.parent, foreign_key: a.foreign_key_name }
        }

        parent_assocs = ResourceAssociation.where(parent: resource.name).map { |a|
          { role: a.has_many? ? "has_many" : "has_one", name: a.has_many_name, target: a.child, foreign_key: a.foreign_key_name }
        }

        child_assocs + parent_assocs
      end
    end
  end
end
