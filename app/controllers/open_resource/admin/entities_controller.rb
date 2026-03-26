# frozen_string_literal: true

module OpenResource
  module Admin
    class EntitiesController < BaseController
      before_action :set_resource

      def index
        model_class = @resource.dynamic_model_class
        @entities = model_class.all
        @attributes = @resource.resource_attributes.order(position: :asc)
      end

      def show
        model_class = @resource.dynamic_model_class
        @entity = model_class.find(params[:id])
        @attributes = @resource.resource_attributes.order(position: :asc)
        @child_assocs = ResourceAssociation.where(child: @resource.name)
        @parent_assocs = ResourceAssociation.where(parent: @resource.name)
      end

      private

      def set_resource
        @resource = Resource.find_by!(name: params[:resource_name])
      end
    end
  end
end
