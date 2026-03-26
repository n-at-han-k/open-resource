# frozen_string_literal: true

# Sizeable — adds a `size` string attribute.
#
# Valid sizes: mini, tiny, small, large, big, huge, massive
#
# Usage:
#   class ButtonComponent < Component
#     include Sizeable
#   end

module Sizeable
  extend ActiveSupport::Concern

  included do
    attribute :size, :string, default: nil
  end
end
