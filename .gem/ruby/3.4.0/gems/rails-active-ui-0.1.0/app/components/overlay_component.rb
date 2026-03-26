# frozen_string_literal: true

# Overlay — floating overlay wrapper for positioned content.
#
# Usage:
#   Overlay {
#     Menu(vertical: true, labeled_icon: true) {
#       MenuItem(href: "#", icon: "twitter") { text "Tweet" }
#     }
#   }

class OverlayComponent < Component
  def to_s
    tag.div(class: "overlay") { @content }
  end
end
