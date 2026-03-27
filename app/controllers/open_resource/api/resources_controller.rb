# frozen_string_literal: true

module OpenResource
  module Api
    class ResourcesController < ApplicationController
      before_action :set_resource
      before_action :set_model

      def index
        @q = @model.ransack(params[:q])
        @entities = @q.result.page(params[:page] || 1).per(@resource.per_page || 25)

        render json: {
          resource: @resource.name,
          entities: @entities.map { |e| serialize_entity(e) },
          meta: {
            current_page: @entities.current_page,
            total_pages: @entities.total_pages,
            total_count: @entities.total_count
          }
        }
      end

      def show
        entity = @model.find(params[:id])
        render json: serialize_entity(entity)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      end

      def create
        entity = @model.new
        entity.assign_properties(permitted_params)
        entity.save!

        render json: serialize_entity(entity), status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def update
        entity = @model.find(params[:id])
        entity.assign_properties(permitted_params)
        entity.save!

        render json: serialize_entity(entity)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      rescue ActiveRecord::RecordInvalid => e
        render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
      end

      def destroy
        entity = @model.find(params[:id])
        entity.destroy!

        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Not found" }, status: :not_found
      end

      private

      def set_resource
        @resource = Resource.find_by(name: params[:resource_name])

        if @resource.nil?
          render json: { error: "Unknown resource: #{params[:resource_name]}" }, status: :not_found
          nil
        end
      end

      def set_model
        @model = @resource.dynamic_model_class
      end

      def permitted_params
        return {} unless params[:entity].is_a?(Hash)

        # Permit all dynamic attributes + FK fields from associations
        attribute_names = @resource.resource_attributes.map(&:name)
        fk_names = @resource.child_associations.map(&:foreign_key_name)
        params.require(:entity).permit(attribute_names + fk_names)
      end

      def serialize_entity(entity)
        attrs = @resource.resource_attributes.map(&:name).index_with do |name|
          entity.send(name)
        end

        # Include FK values from belongs_to associations
        fks = @resource.child_associations.each_with_object({}) do |assoc, hash|
          hash[assoc.foreign_key_name] = entity.read_property(assoc.foreign_key_name)
        end

        {
          id: entity.id,
          **attrs,
          **fks,
          created_at: entity.created_at,
          updated_at: entity.updated_at
        }
      end
    end
  end
end
