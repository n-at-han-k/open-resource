# frozen_string_literal: true

# Alignable — adds an `aligned` string attribute (vertical / horizontal).
#
# Usage:
#   class GridComponent < Component
#     include Alignable                             # default: nil
#   end
#
#   class ColumnComponent < Component
#     include Alignable
#     default aligned: "vertical"                   # override default
#   end

module Alignable
  extend ActiveSupport::Concern

  included do
    attribute :aligned, :string, default: nil
  end
end
