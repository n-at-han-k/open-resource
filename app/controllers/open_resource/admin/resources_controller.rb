# frozen_string_literal: true

module OpenResource
  module Admin
    class ResourcesController < BaseController
      before_action :set_resource, only: [:show, :edit, :update, :destroy]

      def index
        @resources = Resource.all.order(:name)
      end

      def show
        @attributes = @resource.resource_attributes.order(position: :asc)
        @child_assocs = ResourceAssociation.where(child: @resource.name)
        @parent_assocs = ResourceAssociation.where(parent: @resource.name)
      end

      def new
        @resource = Resource.new
      end

      def create
        @resource = Resource.new(resource_params)

        if @resource.save
          redirect_to resource_path(@resource), notice: "Resource '#{@resource.name}' created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @resource.update(resource_params)
          redirect_to resource_path(@resource), notice: "Resource updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @resource.destroy!
        redirect_to resources_path, notice: "Resource '#{@resource.name}' deleted."
      end

      private

      def set_resource
        @resource = Resource.find(params[:id])
      end

      def resource_params
        params.require(:resource).permit(:name, :label, :description, :icon, :per_page)
      end
    end
  end
end
