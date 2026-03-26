# frozen_string_literal: true

# Embed — embedded video/iframe content.
#
# Usage:
#   Embed(source: :youtube, embed_id: "dQw4w9WgXcQ")
#   Embed(source: :vimeo, embed_id: "123456", placeholder: "thumb.jpg")
#   Embed(url: "https://example.com/widget")

class EmbedComponent < Component
  attribute :source,      :string, default: nil
  attribute :embed_id,    :string, default: nil
  attribute :url,         :string, default: nil
  attribute :placeholder, :string, default: nil
  attribute :icon,        :string, default: "video play"
  attribute :autoplay,    :boolean, default: true

  def to_s
    data = { controller: "fui-embed" }
    data[:source] = source if source
    data[:id] = embed_id if embed_id
    data[:url] = url if url
    data[:placeholder] = placeholder if placeholder

    icon_el = tag.i(class: "#{icon} icon")
    placeholder_el = placeholder ? tag.img(class: "placeholder", src: placeholder) : nil

    tag.div(class: "ui embed", data: data) {
      safe_join([ icon_el, placeholder_el, @content ])
    }
  end
end
