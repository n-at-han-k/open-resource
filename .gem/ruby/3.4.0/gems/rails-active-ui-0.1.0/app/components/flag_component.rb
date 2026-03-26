# frozen_string_literal: true

# Flag — country flag icon.
#
# Usage:
#   Flag(country: "us")
#   Flag(country: "fr")

class FlagComponent < Component
  attribute :country, :string, default: nil

  def to_s
    tag.i(class: "#{country} flag")
  end
end
