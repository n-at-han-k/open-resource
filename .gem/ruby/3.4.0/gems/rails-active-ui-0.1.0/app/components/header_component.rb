# frozen_string_literal: true

# Header — page and content headers.
#
# Usage:
#   Header(size: :h2) { text "Page Title" }
#   Header(size: :h3, sub: true) { text "Subtitle" }
#   Header(icon: "settings", dividing: true) { text "Settings" }
#   Header(size: :h4, image: true) { |c|
#     c.header_image { Image(src: "avatar.png", size: "mini", rounded: true) }
#     text "Lena"
#     SubHeader { text "Human Resources" }
#   }

class HeaderComponent < Component
  attribute :size,         :string,  default: "h2"
  attribute :sub,          :boolean, default: false
  attribute :icon,         :string,  default: nil
  attribute :image,        :boolean, default: false
  attribute :dividing,     :boolean, default: false
  attribute :block_header, :boolean, default: false
  attribute :inverted,     :boolean, default: false
  attribute :color,        :string,  default: nil
  attribute :aligned,      :string,  default: nil
  attribute :attached,     :string,  default: nil
  attribute :disabled,     :boolean, default: false
  attribute :floating,     :boolean, default: false

  slot :header_image

  def to_s
    classes = class_names(
      "ui",
      color,
      aligned && "#{aligned} aligned",
      attached && "#{attached} attached",
      { "sub" => sub, "dividing" => dividing, "block" => block_header,
        "inverted" => inverted, "disabled" => disabled, "floating" => floating,
        "icon" => icon && !@content, "image" => image },
      "header"
    )

    tag_name = size.to_s.start_with?("h") ? size.to_s.to_sym : :h2
    icon_el = icon ? tag.i(class: "#{icon} icon") : nil

    if image && @slots[:header_image]
      # Image header: image outside content div, text + sub header inside content div
      tag.public_send(tag_name, class: classes) {
        safe_join([
          @slots[:header_image],
          tag.div(class: "content") { @content }
        ])
      }
    else
      tag.public_send(tag_name, class: classes) {
        safe_join([ icon_el, @content ])
      }
    end
  end
end
