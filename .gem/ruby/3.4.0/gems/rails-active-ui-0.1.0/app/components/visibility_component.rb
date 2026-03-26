# frozen_string_literal: true

# Visibility — scroll-based visibility detection.
#
# Usage:
#   Visibility(once: true) { Image(src: "lazy.jpg") }
#   Visibility(offset: 100) { text "I trigger when visible" }

class VisibilityComponent < Component
  attribute :type,   :string,  default: nil
  attribute :offset, :integer, default: 0
  attribute :once,   :boolean, default: false

  def to_s
    data = { controller: "fui-visibility" }
    data[:fui_visibility_type_value] = type if type
    data[:fui_visibility_offset_value] = offset if offset > 0
    data[:fui_visibility_once_value] = "true" if once

    tag.div(data: data) { @content }
  end
end
