# frozen_string_literal: true

# SegmentGroup — wraps multiple segments into a visual group.
#
# Usage:
#   SegmentGroup {
#     Segment { text "Top" }
#     Segment { text "Bottom" }
#   }
#
#   SegmentGroup(aligned: "horizontal") {
#     Segment { text "Left" }
#     Segment { text "Right" }
#   }

class SegmentGroupComponent < Component
  include Alignable

  attribute :compact,    :boolean, default: false
  attribute :basic,      :boolean, default: false
  attribute :equal_width, :boolean, default: false
  attribute :wrapping,   :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      aligned,
      { "compact" => compact,
        "basic" => basic, "equal width" => equal_width,
        "wrapping" => wrapping },
      "segments"
    )

    tag.div(class: classes) { @content }
  end
end
