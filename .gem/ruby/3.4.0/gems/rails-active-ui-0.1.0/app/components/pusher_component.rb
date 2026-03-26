# frozen_string_literal: true

# Pusher — main content wrapper for Sidebar layouts.
# The pusher wraps the page content that gets pushed when a sidebar opens.
#
# Usage:
#   Sidebar(inverted: true) {
#     MenuItem(href: "/") { text "Home" }
#   }
#   Pusher {
#     text "Main content here"
#   }

class PusherComponent < Component
  def to_s
    tag.div(class: "pusher") { @content }
  end
end
