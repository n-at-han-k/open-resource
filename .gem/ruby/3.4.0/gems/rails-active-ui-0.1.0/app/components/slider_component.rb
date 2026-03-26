# frozen_string_literal: true

# Slider — range slider control.
#
# Usage:
#   Slider(min: 0, max: 100, value: 50, name: "volume")
#   Slider(min: 0, max: 10, step: 1, labeled: true, color: :blue)

class SliderComponent < Component
  attribute :min,      :integer, default: 0
  attribute :max,      :integer, default: 100
  attribute :value,    :integer, default: 0
  attribute :step,     :integer, default: 1
  attribute :labeled,  :boolean, default: false
  attribute :vertical, :boolean, default: false
  attribute :reversed, :boolean, default: false
  attribute :color,    :string,  default: nil
  attribute :name,     :string,  default: nil
  attribute :disabled, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      color,
      { "labeled" => labeled,
        "vertical" => vertical,
        "reversed" => reversed,
        "disabled" => disabled },
      "slider"
    )

    data = {
      controller: "fui-slider",
      fui_slider_min_value: min,
      fui_slider_max_value: max,
      fui_slider_start_value: value,
      fui_slider_step_value: step
    }

    name_el = name ? tag.input(type: "hidden", name: name, value: value) : nil

    tag.div(class: classes, data: data) {
      safe_join([ name_el, @content ])
    }
  end
end
