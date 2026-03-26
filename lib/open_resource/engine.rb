# frozen_string_literal: true

module OpenResource
  class Engine < ::Rails::Engine
    isolate_namespace OpenResource

    # Append engine migrations to the host app's migration paths.
    initializer "open_resource.append_migrations" do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
        ActiveRecord::Migrator.migrations_paths << expanded_path
      end
    end
  end
end
