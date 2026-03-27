# frozen_string_literal: true

require "graphiql/rails"

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

    # Configure GraphiQL in-browser IDE defaults.
    initializer "open_resource.graphiql" do
      if defined?(GraphiQL::Rails)
        GraphiQL::Rails.config.tap do |c|
          c.initial_query = <<~GQL
            # Welcome to the OpenResource GraphQL Explorer!
            #
            # All resource types, queries, and mutations are
            # auto-generated from your resource definitions.
            #
            # Try the Docs panel on the right to browse the schema.
            {
              __schema {
                queryType { name }
                mutationType { name }
                types {
                  name
                  description
                }
              }
            }
          GQL
        end
      end
    end

    # Build the dynamic GraphQL schema at boot (after all initializers run).
    # Guard with table_exists? so migrations can run before tables exist.
    config.after_initialize do
      if ActiveRecord::Base.connection_pool.with_connection { Resource.table_exists? rescue false }
        GraphqlSchemaFactory.build_all
      end
    end
  end
end
