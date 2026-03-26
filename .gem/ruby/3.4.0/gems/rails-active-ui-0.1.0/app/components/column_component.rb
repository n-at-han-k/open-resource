# frozen_string_literal: true

# Column — grid column with responsive width support.
#
# Usage:
#   Grid(stackable: true) {
#     Column(width: 4) { text "Four wide" }
#     Column(computer: 8, tablet: 16) { text "Responsive" }
#     Column(computer: 4, tablet: 8, mobile: 16, aligned: "center") { text "All breakpoints" }
#   }

class ColumnComponent < Component
  NUMBERS = %w[one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen].freeze

  attribute :width,    :integer, default: nil
  attribute :computer, :integer, default: nil
  attribute :tablet,   :integer, default: nil
  attribute :mobile,   :integer, default: nil
  attribute :widescreen, :integer, default: nil
  attribute :large_screen, :integer, default: nil
  attribute :aligned,  :string,  default: nil
  attribute :floated,  :string,  default: nil
  attribute :only,     :string,  default: nil
  attribute :color,    :string,  default: nil

  def to_s
    # Cannot use class_names here — it deduplicates tokens, which breaks
    # responsive widths where "wide" appears for each breakpoint.
    classes = [
      width_class(width, nil),
      width_class(computer, "computer"),
      width_class(tablet, "tablet"),
      width_class(mobile, "mobile"),
      width_class(widescreen, "widescreen"),
      width_class(large_screen, "large screen"),
      only_class,
      (aligned && "#{aligned} aligned"),
      (floated && "#{floated} floated"),
      color,
      "column"
    ].compact.join(" ")

    tag.div(class: classes) { @content }
  end

  private

  # Supports single ("mobile") or multiple ("tablet mobile") only values.
  # Each device word gets "only" appended: "tablet only mobile only"
  def only_class
    return unless only

    only.split.map { |device| "#{device} only" }.join(" ")
  end

  def width_class(value, device)
    return unless value && value.between?(1, 16)

    word = NUMBERS[value - 1]
    device ? "#{word} wide #{device}" : "#{word} wide"
  end
end
