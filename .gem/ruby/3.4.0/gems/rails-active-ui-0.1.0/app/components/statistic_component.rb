# frozen_string_literal: true

# Statistic — numeric statistics display.
#
# Usage:
#   Statistic(color: :blue) { |c|
#     c.value { text "5,550" }
#     c.label { text "Downloads" }
#   }
#   Statistic(horizontal: true) { |c|
#     c.value { text "22" }
#     c.label { text "Members" }
#   }

class StatisticComponent < Component
  attribute :horizontal, :boolean, default: false
  attribute :color,      :string,  default: nil
  attribute :size,       :string,  default: nil
  attribute :inverted,   :boolean, default: false
  attribute :floated,    :string,  default: nil

  slot :value
  slot :label

  def to_s
    classes = class_names(
      "ui",
      color,
      size,
      floated && "#{floated} floated",
      { "horizontal" => horizontal,
        "inverted" => inverted },
      "statistic"
    )

    value_el = @slots[:value] ? tag.div(class: "value") { @slots[:value] } : nil
    label_el = @slots[:label] ? tag.div(class: "label") { @slots[:label] } : nil

    tag.div(class: classes) {
      safe_join([ value_el, label_el, @content.presence ])
    }
  end
end
