# frozen_string_literal: true

# Reveal — hidden content revealed on hover/active.
#
# Usage:
#   Reveal(type: :fade) { |c|
#     c.visible { Image(src: "before.jpg") }
#     c.hidden  { Image(src: "after.jpg") }
#   }

class RevealComponent < Component
  attribute :type,     :string,  default: "fade"
  attribute :active,   :boolean, default: false
  attribute :instant,  :boolean, default: false
  attribute :disabled, :boolean, default: false
  attribute :move_direction, :string, default: nil

  slot :visible
  slot :hidden

  def to_s
    classes = class_names(
      "ui",
      type,
      (type == "move") && move_direction,
      { "active" => active,
        "instant" => instant,
        "disabled" => disabled },
      "reveal"
    )

    visible_el = @slots[:visible] ? tag.div(class: "visible content") { @slots[:visible] } : nil
    hidden_el  = @slots[:hidden]  ? tag.div(class: "hidden content") { @slots[:hidden] } : nil

    tag.div(class: classes) {
      safe_join([ visible_el, hidden_el, @content ])
    }
  end
end
