# frozen_string_literal: true

# Ad — standard ad unit sizes following IAB standards.
#
# Usage:
#   Ad(unit: :leaderboard)
#   Ad(unit: :medium_rectangle, test: "Ad Placeholder")

class AdComponent < Component
  attribute :unit, :string, default: nil
  attribute :test, :string, default: nil

  def to_s
    unit_class = unit.to_s.tr("_", " ")

    classes = class_names(
      "ui",
      unit_class,
      { "test" => test },
      "ad"
    )

    opts = { class: classes }
    opts[:data] = { text: test } if test

    tag.div(**opts) { @content }
  end
end
