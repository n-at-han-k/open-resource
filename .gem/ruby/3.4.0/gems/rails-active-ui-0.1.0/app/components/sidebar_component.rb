# frozen_string_literal: true

# Sidebar — slide-out sidebar navigation.
#
# Usage:
#   Sidebar(direction: :left, visible: true, inverted: true) {
#     MenuItem(href: "#") { text "Home" }
#     MenuItem(href: "#") { text "Settings" }
#   }

class SidebarComponent < Component
  attribute :direction,  :string,  default: "left"
  attribute :transition, :string,  default: "overlay"
  attribute :visible,    :boolean, default: false
  attribute :inverted,   :boolean, default: false
  attribute :vertical,   :boolean, default: true
  attribute :width,      :string,  default: nil

  def to_s
    classes = class_names(
      "ui",
      direction,
      width,
      { "inverted" => inverted,
        "vertical" => vertical,
        "visible" => visible },
      "sidebar",
      "menu"
    )

    tag.div(class: classes, data: { controller: "fui-sidebar", fui_sidebar_transition_value: transition }) { @content }
  end
end
