# frozen_string_literal: true

# Image — image element. Merges the holy spec primitive with Fomantic-UI image.
#
# Usage:
#   Image(src: "photo.jpg")
#   Image(src: "avatar.png", avatar: true, size: :mini)
#   Image(src: "logo.svg", circular: true, centered: true)

class ImageComponent < Component
  attribute :src,      :string,  default: nil
  attribute :alt,      :string,  default: ""
  attribute :size,     :string,  default: nil
  attribute :width,    :integer, default: nil
  attribute :height,   :integer, default: nil
  attribute :shrink,   :boolean, default: true
  attribute :rounded,  :boolean, default: false
  attribute :circular, :boolean, default: false
  attribute :bordered, :boolean, default: false
  attribute :fluid,    :boolean, default: false
  attribute :avatar,   :boolean, default: false
  attribute :centered, :boolean, default: false
  attribute :spaced,   :string,  default: nil
  attribute :hidden,   :boolean, default: false
  attribute :disabled, :boolean, default: false
  attribute :inline,   :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      spaced && "#{spaced} spaced",
      { "rounded" => rounded, "circular" => circular, "bordered" => bordered,
        "fluid" => fluid, "avatar" => avatar, "centered" => centered,
        "hidden" => hidden, "disabled" => disabled, "inline" => inline },
      "image"
    )

    opts = { class: classes, src: src, alt: alt }
    opts[:width] = width if width
    opts[:height] = height if height
    opts[:style] = "flex-shrink:0" unless shrink

    tag.img(**opts)
  end
end
