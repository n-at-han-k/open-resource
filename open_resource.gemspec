# frozen_string_literal: true

require_relative "lib/open_resource/version"

Gem::Specification.new do |spec|
  spec.name        = "open_resource"
  spec.version     = OpenResource::VERSION
  spec.authors     = ["OpenResource Contributors"]
  spec.email       = ["dev@example.com"]
  spec.homepage    = "https://github.com/example/open_resource"
  spec.summary     = "Dynamic resource creation framework with EAV pattern"
  spec.description = "A mountable Rails engine that dynamically creates RESTful resources from YAML configuration using PostgreSQL JSONB EAV pattern."
  spec.license     = "MIT"

  spec.required_ruby_version = ">= 3.2"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 7.0"
  spec.add_dependency "pg", ">= 1.5"          # PostgreSQL for JSONB
  spec.add_dependency "ransack", ">= 4.0"     # Advanced filtering
  spec.add_dependency "kaminari", ">= 1.2"    # Pagination
  spec.add_dependency "rails-active-ui"        # Fomantic-UI component library
  spec.add_dependency "graphql", "~> 2.0"      # GraphQL runtime + schema DSL
  spec.add_dependency "graphiql-rails", "~> 1.10" # In-browser GraphQL IDE
end
