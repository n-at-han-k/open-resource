# frozen_string_literal: true

# Flyout — slide-out panel from screen edge.
#
# Usage:
#   Flyout(direction: :right) { |c|
#     c.header { text "Settings" }
#     c.content { text "Flyout body" }
#     c.actions {
#       Button(variant: :primary) { text "Save" }
#     }
#   }

class FlyoutComponent < Component
  attribute :direction, :string,  default: "right"
  attribute :closable,  :boolean, default: true

  slot :header
  slot :content
  slot :actions

  def to_s
    classes = class_names(
      "ui",
      direction,
      "flyout"
    )

    data = { controller: "fui-flyout" }
    data[:fui_flyout_closable_value] = "false" unless closable

    close_el = closable ? tag.i(class: "close icon") : nil
    header_el = @slots[:header] ? tag.div(class: "header") { @slots[:header] } : nil
    content_el = @slots[:content] ? tag.div(class: "content") { @slots[:content] } : nil
    actions_el = @slots[:actions] ? tag.div(class: "actions") { @slots[:actions] } : nil

    tag.div(class: classes, data: data) {
      safe_join([ close_el, header_el, content_el, @content.presence, actions_el ])
    }
  end
end
