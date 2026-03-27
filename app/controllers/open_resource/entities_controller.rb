# frozen_string_literal: true

module OpenResource
  class EntitiesController < ApplicationController
    before_action :set_resource

    def index
      model_class = @resource.dynamic_model_class
      @q = model_class.ransack(params[:q])
      @entities = @q.result
      @attributes = @resource.resource_attributes.order(position: :asc)
      @search_attribute = @attributes.find { |a|
        a.filterable && %w[string text email url].include?(a.field_type)
      }
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
