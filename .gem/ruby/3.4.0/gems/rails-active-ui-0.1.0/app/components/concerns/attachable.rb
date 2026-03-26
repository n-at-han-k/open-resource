# frozen_string_literal: true

# Attachable — adds an `attached` boolean attribute to a component.
#
# Usage:
#   class ButtonComponent < Component
#     include Attachable
#   end

module Attachable
  extend ActiveSupport::Concern

  included do
    attribute :attached, :boolean, default: false
  end
end
