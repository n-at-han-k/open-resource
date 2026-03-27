# frozen_string_literal: true

module OpenResource
  class ApplicationController < ::ApplicationController
    helper OpenResource::AdminHelper

    before_action :configure_layout

    private

    def configure_layout
      session[:or_layout] = params[:layout_view] if params[:layout_view].present?
    end

    def current_layout
      session[:or_layout] || "table"
    end
    helper_method :current_layout
  end
end
