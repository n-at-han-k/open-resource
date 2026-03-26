# frozen_string_literal: true

# Positionable — adds a `position` string attribute to a component.
#
# Usage:
#   class MenuComponent < Component
#     include Positionable                        # default: nil
#   end
#
#   class RailComponent < Component
#     include Positionable
#     default position: "left"                    # override default
#   end

module Positionable
  extend ActiveSupport::Concern

  included do
    attribute :position, :string, default: nil
  end
end
