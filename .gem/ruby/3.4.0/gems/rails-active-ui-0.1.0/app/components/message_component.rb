# frozen_string_literal: true

# Message — alert/info messages.
#
# Usage:
#   Message(type: :success) { text "It worked!" }
#   Message(type: :error, icon: "exclamation triangle") { |c|
#     c.header { text "Error" }
#     text "Something went wrong."
#   }
#   Message(dismissible: true) { text "Notice" }

class MessageComponent < Component
  include Attachable

  attribute :type,        :string,  default: nil
  attribute :icon,        :string,  default: nil
  attribute :dismissible, :boolean, default: false
  attribute :floating,    :boolean, default: false
  attribute :compact,     :boolean, default: false
  attribute :color,       :string,  default: nil
  attribute :size,        :string,  default: nil
  attribute :hidden,      :boolean, default: false
  attribute :visible,     :boolean, default: false

  slot :header

  def to_s
    classes = class_names(
      "ui",
      size,
      color,
      type,
      { "attached" => attached,
        "icon" => icon,
        "floating" => floating,
        "compact" => compact,
        "hidden" => hidden,
        "visible" => visible },
      "message"
    )

    close_el = dismissible ? tag.i(class: "close icon") : nil
    icon_el = icon ? tag.i(class: "#{icon} icon") : nil
    header_el = @slots[:header] ? tag.div(class: "header") { @slots[:header] } : nil

    content_parts = safe_join([ header_el, @content.presence ])
    content_wrapper = icon ? tag.div(class: "content") { content_parts } : content_parts

    tag.div(class: classes) {
      safe_join([ close_el, icon_el, content_wrapper ])
    }
  end
end
