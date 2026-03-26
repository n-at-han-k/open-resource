# frozen_string_literal: true

# Toast — toast notifications.
#
# Usage:
#   Toast(title: "Success", message: "Item saved.", type: :success)
#   Toast(title: "Error", message: "Something went wrong.", type: :error, position: "bottom right")

class ToastComponent < Component
  include Positionable
  default position: "top right"

  attribute :title,         :string,  default: nil
  attribute :message,       :string,  default: nil
  attribute :type,          :string,  default: "neutral"
  attribute :display_time,  :integer, default: 3000
  attribute :close_icon,    :boolean, default: false
  attribute :compact,       :boolean, default: true
  attribute :show_progress, :boolean, default: false

  def to_s
    data = {
      controller: "fui-toast",
      fui_toast_class_value: type,
      fui_toast_position_value: position,
      fui_toast_display_time_value: display_time
    }
    data[:fui_toast_title_value] = title if title
    data[:fui_toast_message_value] = message if message
    data[:fui_toast_close_icon_value] = "true" if close_icon
    data[:fui_toast_compact_value] = "true" if compact
    data[:fui_toast_show_progress_value] = "true" if show_progress

    tag.div(data: data) { @content }
  end
end
