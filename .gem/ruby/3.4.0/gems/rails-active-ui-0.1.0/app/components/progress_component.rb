# frozen_string_literal: true

# Progress — progress bars.
#
# Usage:
#   Progress(value: 65, total: 100, color: :green, active: true) { |c|
#     c.bar { }
#     c.label { text "65% Complete" }
#   }
#   Progress(value: 3, total: 10, indicating: true)

class ProgressComponent < Component
  attribute :value,      :integer, default: 0
  attribute :total,      :integer, default: 100
  attribute :indicating, :boolean, default: false
  attribute :active,     :boolean, default: false
  attribute :color,      :string,  default: nil
  attribute :size,       :string,  default: nil
  attribute :attached,   :string,  default: nil
  attribute :inverted,   :boolean, default: false
  attribute :disabled,   :boolean, default: false

  slot :bar
  slot :label

  def to_s
    percent = total > 0 ? ((value.to_f / total) * 100).round : 0

    classes = class_names(
      "ui",
      color,
      size,
      attached && "#{attached} attached",
      { "indicating" => indicating,
        "active" => active,
        "inverted" => inverted,
        "disabled" => disabled },
      "progress"
    )

    bar_el = tag.div(class: "bar", style: "width:#{percent}%") { @slots[:bar] }
    label_el = @slots[:label] ? tag.div(class: "label") { @slots[:label] } : nil

    tag.div(class: classes, data: { controller: "fui-progress", percent: percent }) {
      safe_join([ bar_el, label_el, @content.presence ])
    }
  end
end
