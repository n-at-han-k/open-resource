# frozen_string_literal: true

# Label — labels and tags.
#
# Usage:
#   Label(color: :blue) { text "New" }
#   Label(tag_style: true, color: :teal) { text "Featured" }
#   Label(ribbon: true, color: :red) { text "Sale" }
#   Label(icon: "mail", detail: "23") { text "Mail" }

class LabelComponent < Component
  include Attachable

  attribute :color,    :string,  default: nil
  attribute :size,     :string,  default: nil
  attribute :pointing, :string,  default: nil
  attribute :corner,   :string,  default: nil
  attribute :ribbon,   :boolean, default: false
  attribute :circular, :boolean, default: false
  attribute :floating, :boolean, default: false
  attribute :tag_style, :boolean, default: false
  attribute :detail,   :string,  default: nil
  attribute :icon,     :string,  default: nil
  attribute :image,    :boolean, default: false
  attribute :basic,    :boolean, default: false
  attribute :horizontal, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      color,
      size,
      pointing && "#{pointing} pointing",
      corner && "#{corner} corner",
      { "attached" => attached,
        "ribbon" => ribbon, "circular" => circular, "floating" => floating,
        "tag" => tag_style, "image" => image, "basic" => basic,
        "horizontal" => horizontal },
      "label"
    )

    icon_el = icon ? tag.i(class: "#{icon} icon") : nil
    detail_el = detail ? tag.div(class: "detail") { detail } : nil

    tag.div(class: classes) {
      safe_join([ icon_el, @content, detail_el ])
    }
  end
end
