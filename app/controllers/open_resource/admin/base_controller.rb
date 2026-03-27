# frozen_string_literal: true

module OpenResource
  module Admin
    class BaseController < ApplicationController
      helper OpenResource::AdminHelper
    end
  end
end
