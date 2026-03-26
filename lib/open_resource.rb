# frozen_string_literal: true

require "ui"
require "open_resource/version"
require "open_resource/engine"

module OpenResource
  autoload :DynamicModelFactory, "open_resource/dynamic_model_factory"
  autoload :YamlLoader, "open_resource/yaml_loader"

  # Loads YAML resource definitions and builds dynamic models.
  # Called during engine initialization after the database is available.
  def self.bootstrap!
    return unless database_ready?

    Rails.logger.info "[OpenResource] Bootstrapping dynamic resources..."

    # 1. Sync YAML config to database.
    YamlLoader.load_all

    # 2. Build dynamic model classes.
    DynamicModelFactory.build_all

    Rails.logger.info "[OpenResource] Bootstrap complete."
  rescue => e
    Rails.logger.error "[OpenResource] Bootstrap failed: #{e.message}"
    Rails.logger.error e.backtrace.first(10).join("\n")
  end

  # Checks whether the database connection is established and our tables exist.
  def self.database_ready?
    ActiveRecord::Base.connection.table_exists?("open_resource_resources")
  rescue ActiveRecord::NoDatabaseError, ActiveRecord::ConnectionNotEstablished, PG::ConnectionBad
    false
  end
end
