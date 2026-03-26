# frozen_string_literal: true

module OpenResource
  module Admin
    class BaseController < ApplicationController
      layout "open_resource/layouts/admin"
      helper OpenResource::AdminHelper
    end
  end
end
