# frozen_string_literal: true

# Item — individual content item within an ItemGroup.
#
# Usage:
#   ItemGroup(divided: true) {
#     Item { |c|
#       c.image { Image(src: "product.jpg", size: "small") }
#       c.header { text "Product Name" }
#       c.meta { text "$19.99" }
#       c.description { text "A great product." }
#       c.extra { text "In stock" }
#     }
#   }

class ItemComponent < Component
  slot :image
  slot :header
  slot :meta
  slot :description
  slot :extra

  def to_s
    image_el = @slots[:image] ? tag.div(class: "image") { @slots[:image] } : nil

    content_parts = [
      (@slots[:header] ? tag.div(class: "header") { @slots[:header] } : nil),
      (@slots[:meta] ? tag.div(class: "meta") { @slots[:meta] } : nil),
      (@slots[:description] ? tag.div(class: "description") { @slots[:description] } : nil),
      (@slots[:extra] ? tag.div(class: "extra") { @slots[:extra] } : nil)
    ].compact

    content_el = content_parts.any? ? tag.div(class: "content") { safe_join(content_parts) } : nil

    tag.div(class: "item") {
      safe_join([ image_el, content_el, @content.presence ])
    }
  end
end
