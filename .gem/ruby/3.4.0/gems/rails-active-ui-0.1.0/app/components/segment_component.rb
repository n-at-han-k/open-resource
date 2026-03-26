# frozen_string_literal: true

# Segment — grouped content sections.
#
# Usage:
#   Segment { text "Basic segment" }
#   Segment(raised: true, padded: :very) { text "Raised" }
#   Segment(inverted: true, color: :blue) { text "Blue inverted" }

class SegmentComponent < Component
  include Attachable
  include Sizeable

  attribute :raised,    :boolean, default: false
  attribute :stacked,   :boolean, default: false
  attribute :piled,     :boolean, default: false
  attribute :vertical,  :boolean, default: false
  attribute :inverted,  :boolean, default: false
  attribute :padded,    :string,  default: nil
  attribute :compact,   :boolean, default: false
  attribute :color,     :string,  default: nil
  attribute :loading,   :boolean, default: false
  attribute :clearing,  :boolean, default: false
  attribute :basic,     :boolean, default: false
  attribute :circular,  :boolean, default: false
  attribute :disabled,  :boolean, default: false
  attribute :placeholder_seg, :boolean, default: false
  attribute :secondary, :boolean, default: false
  attribute :tertiary,  :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      color,
      padded && "#{padded == "very" ? "very " : ""}padded",
      { "attached" => attached,
        "raised" => raised,
        "stacked" => stacked,
        "piled" => piled,
        "vertical" => vertical,
        "inverted" => inverted,
        "compact" => compact,
        "loading" => loading,
        "clearing" => clearing,
        "basic" => basic,
        "circular" => circular,
        "disabled" => disabled,
        "placeholder" => placeholder_seg,
        "secondary" => secondary,
        "tertiary" => tertiary },
      "segment"
    )

    tag.div(class: classes) { @content }
  end
end
