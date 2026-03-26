# frozen_string_literal: true

# SubHeader — sub header text within a Header.
#
# Usage:
#   Header(size: :h2) {
#     text "Main Title"
#     SubHeader { text "A subtitle or description" }
#   }

class SubHeaderComponent < Component
  def to_s
    tag.div(class: "sub header") { @content }
  end
end
