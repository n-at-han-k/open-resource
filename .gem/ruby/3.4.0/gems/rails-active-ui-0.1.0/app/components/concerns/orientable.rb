# frozen_string_literal: true

# Orientable — adds an `orientation` string attribute (vertical / horizontal).
#
# Usage:
#   class DividerComponent < Component
#     include Orientable                            # default: nil
#   end
#
#   class MenuComponent < Component
#     include Orientable
#     default orientation: "horizontal"             # override default
#   end

module Orientable
  extend ActiveSupport::Concern

  included do
    attribute :orientation, :string, default: nil
  end
end
