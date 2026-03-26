# frozen_string_literal: true

module Ui
  class Engine < ::Rails::Engine
    initializer "ui.autoload_paths" do |app|
      app.config.autoload_paths += [ root.join("app", "lib").to_s ]
    end

    initializer "ui.assets" do |app|
      app.config.assets.paths << root.join("formantic-ui")
      app.config.assets.paths << root.join("app/javascript")
    end

    initializer "ui.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end

    initializer "ui.helpers" do
      ActiveSupport.on_load(:action_view) do
        include ComponentHelper
        include FuiHelper
      end
    end
  end
end
