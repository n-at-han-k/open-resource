# frozen_string_literal: true

# Card — content cards with multiple regions.
#
# Usage:
#   Card(fluid: true) { |c|
#     c.image { Image(src: "photo.jpg") }
#     c.header { text "Title" }
#     c.meta { text "Subtitle" }
#     c.description { text "Body text" }
#     c.extra { text "Extra content" }
#   }

class CardComponent < Component
  attribute :fluid,    :boolean, default: false
  attribute :centered, :boolean, default: false
  attribute :raised,   :boolean, default: false
  attribute :link,     :boolean, default: false
  attribute :color,    :string,  default: nil
  attribute :href,     :string,  default: nil

  slot :image
  slot :header
  slot :meta
  slot :description
  slot :extra

  def to_s
    classes = class_names(
      "ui",
      color,
      { "fluid" => fluid, "centered" => centered, "raised" => raised,
        "link" => link || href },
      "card"
    )

    image_el = @slots[:image] ? tag.div(class: "image") { @slots[:image] } : nil

    content_parts = [
      @slots[:header] ? tag.div(class: "header") { @slots[:header] } : nil,
      @slots[:meta] ? tag.div(class: "meta") { @slots[:meta] } : nil,
      @slots[:description] ? tag.div(class: "description") { @slots[:description] } : nil
    ].compact

    content_el = content_parts.any? ? tag.div(class: "content") { safe_join(content_parts) } : nil
    extra_el = @slots[:extra] ? tag.div(class: "extra content") { @slots[:extra] } : nil

    inner = safe_join([ image_el, content_el, @content.presence, extra_el ])

    if href
      tag.a(class: classes, href: href) { inner }
    else
      tag.div(class: classes) { inner }
    end
  end
end
