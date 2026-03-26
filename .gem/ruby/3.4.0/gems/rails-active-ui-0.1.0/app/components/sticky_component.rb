# frozen_string_literal: true

# Sticky — sticky/fixed position elements that follow scroll.
#
# Usage:
#   Sticky { text "I stick on scroll" }
#   Sticky(offset: 50, pushing: true) { text "Sticky header" }

class StickyComponent < Component
  attribute :context, :string,  default: nil
  attribute :pushing, :boolean, default: false
  attribute :offset,  :integer, default: 0

  def to_s
    data = { controller: "fui-sticky" }
    data[:fui_sticky_context_value] = context if context
    data[:fui_sticky_pushing_value] = "true" if pushing
    data[:fui_sticky_offset_value] = offset if offset > 0

    tag.div(class: "ui sticky", data: data) { @content }
  end
end
