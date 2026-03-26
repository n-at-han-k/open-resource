# frozen_string_literal: true

# Transition — CSS animation framework.
#
# Usage:
#   Transition(animation: :fade, visible: true) { text "Fading content" }
#   Transition(animation: :scale, duration: 500) { text "Scaling content" }

class TransitionComponent < Component
  attribute :animation, :string,  default: "fade"
  attribute :duration,  :integer, default: 500
  attribute :visible,   :boolean, default: true

  def to_s
    classes = class_names(
      animation,
      { "visible" => visible,
        "hidden" => !visible },
      "transition"
    )

    tag.div(
      class: classes,
      style: "animation-duration:#{duration}ms",
      data: {
        controller: "fui-transition",
        fui_transition_animation_value: animation,
        fui_transition_duration_value: duration
      }
    ) { @content }
  end
end
