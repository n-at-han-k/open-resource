# frozen_string_literal: true

# Rail — content rails floating alongside main content.
#
# Usage:
#   Rail(position: :left) { text "Side content" }
#   Rail(position: :right, close: true) { text "Close rail" }

class RailComponent < Component
  include Positionable
  default position: "left"

  attribute :close,    :boolean, default: false
  attribute :attached, :boolean, default: false
  attribute :dividing, :boolean, default: false
  attribute :internal, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      position,
      { "close" => close,
        "attached" => attached,
        "dividing" => dividing,
        "internal" => internal },
      "rail"
    )

    tag.div(class: classes) { @content }
  end
end
