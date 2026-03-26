# frozen_string_literal: true

module OpenResource
  module Admin
    class AssociationsController < BaseController
      before_action :set_association, only: [:edit, :update, :destroy]

      def index
        @associations = ResourceAssociation.all.order(:child, :parent)
      end

      def new
        @association = ResourceAssociation.new(has_many: true)
        @resources = Resource.all.order(:name)
      end

      def create
        @association = ResourceAssociation.new(association_params)

        if @association.save
          redirect_to associations_path, notice: "Association created."
        else
          @resources = Resource.all.order(:name)
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @resources = Resource.all.order(:name)
      end

      def update
        if @association.update(association_params)
          redirect_to associations_path, notice: "Association updated."
        else
          @resources = Resource.all.order(:name)
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @association.destroy!
        redirect_to associations_path, notice: "Association deleted."
      end

      private

      def set_association
        @association = ResourceAssociation.find(params[:id])
      end

      def association_params
        params.require(:resource_association).permit(:child, :parent, :has_many, :name)
      end
    end
  end
end
