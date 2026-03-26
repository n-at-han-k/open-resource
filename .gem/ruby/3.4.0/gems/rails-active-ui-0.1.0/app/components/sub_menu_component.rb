# frozen_string_literal: true

# SubMenu — sub-menu or positioned menu group within a Menu.
#
# Usage:
#   Menu {
#     MenuItem(href: "/") { text "Home" }
#     SubMenu(position: "right") {
#       MenuItem(href: "/login") { text "Login" }
#     }
#   }

class SubMenuComponent < Component
  include Positionable

  def to_s
    classes = class_names(
      position,
      "menu"
    )

    tag.div(class: classes) { @content }
  end
end
