# frozen_string_literal: true

# State — UI state management for elements.
#
# Usage:
#   State(text_active: "Following", text_inactive: "Follow") {
#     Button { text "Follow" }
#   }

class StateComponent < Component
  attribute :text_active,   :string, default: nil
  attribute :text_inactive, :string, default: nil
  attribute :class_active,  :string, default: nil
  attribute :class_inactive, :string, default: nil

  def to_s
    data = { controller: "fui-state" }
    data[:fui_state_text_active_value] = text_active if text_active
    data[:fui_state_text_inactive_value] = text_inactive if text_inactive
    data[:fui_state_class_active_value] = class_active if class_active
    data[:fui_state_class_inactive_value] = class_inactive if class_inactive

    tag.div(data: data) { @content }
  end
end
