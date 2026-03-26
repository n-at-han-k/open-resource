# frozen_string_literal: true

module OpenResource
  module Admin
    class AttributesController < BaseController
      before_action :set_resource
      before_action :set_attribute, only: [:edit, :update, :destroy]

      def new
        @attribute = @resource.resource_attributes.build
      end

      def create
        @attribute = @resource.resource_attributes.build(attribute_params)

        if @attribute.save
          redirect_to resource_path(@resource), notice: "Attribute '#{@attribute.name}' created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @attribute.update(attribute_params)
          redirect_to resource_path(@resource), notice: "Attribute updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @attribute.destroy!
        redirect_to resource_path(@resource), notice: "Attribute '#{@attribute.name}' deleted."
      end

      private

      def set_resource
        @resource = Resource.find(params[:resource_id])
      end

      def set_attribute
        @attribute = @resource.resource_attributes.find(params[:id])
      end

      def attribute_params
        params.require(:resource_attribute).permit(
          :name, :label, :field_type, :required, :default_value,
          :position, :filterable, :sortable, :index_visible,
          :show_visible, :form_visible
        )
      end
    end
  end
end
