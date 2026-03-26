# frozen_string_literal: true

require "ui"
require "open_resource/version"
require "open_resource/engine"

module OpenResource
  autoload :DynamicModelFactory, "open_resource/dynamic_model_factory"
  autoload :YamlLoader, "open_resource/yaml_loader"
end
