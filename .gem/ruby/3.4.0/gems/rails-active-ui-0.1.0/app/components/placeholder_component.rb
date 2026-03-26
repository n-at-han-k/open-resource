# frozen_string_literal: true

# Placeholder — skeleton/placeholder content while loading.
#
# Usage:
#   Placeholder { |c|
#     c.header_slot {
#       text '<div class="line"></div><div class="line"></div>'.html_safe
#     }
#     c.paragraph {
#       text '<div class="line"></div><div class="line"></div>'.html_safe
#     }
#   }

class PlaceholderComponent < Component
  attribute :fluid,    :boolean, default: false
  attribute :inverted, :boolean, default: false

  slot :header_slot
  slot :paragraph
  slot :image_slot

  def to_s
    classes = class_names(
      "ui",
      { "fluid" => fluid,
        "inverted" => inverted },
      "placeholder"
    )

    header_el = @slots[:header_slot] ? tag.div(class: "header") { @slots[:header_slot] } : nil
    para_el = @slots[:paragraph] ? tag.div(class: "paragraph") { @slots[:paragraph] } : nil
    image_el = @slots[:image_slot] ? tag.div(class: "image") { @slots[:image_slot] } : nil

    tag.div(class: classes) {
      safe_join([ header_el, para_el, image_el, @content.presence ])
    }
  end
end
