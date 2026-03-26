# frozen_string_literal: true

# Icon — icon element using Fomantic-UI icon font.
#
# Usage:
#   Icon(name: "home")
#   Icon(name: "heart", color: :red, size: :large)
#   Icon(name: "spinner", loading: true)

class IconComponent < Component
  attribute :name,     :string,  default: nil
  attribute :size,     :string,  default: nil
  attribute :color,    :string,  default: nil
  attribute :disabled, :boolean, default: false
  attribute :loading,  :boolean, default: false
  attribute :fitted,   :boolean, default: false
  attribute :link,     :boolean, default: false
  attribute :circular, :boolean, default: false
  attribute :bordered, :boolean, default: false
  attribute :inverted, :boolean, default: false
  attribute :flipped,  :string,  default: nil
  attribute :rotated,  :string,  default: nil
  attribute :corner,   :string,  default: nil

  def to_s
    classes = class_names(
      name,
      size,
      color,
      flipped && "#{flipped} flipped",
      rotated && "#{rotated} rotated",
      corner && "#{corner} corner",
      { "disabled" => disabled, "loading" => loading, "fitted" => fitted,
        "link" => link, "circular" => circular, "bordered" => bordered,
        "inverted" => inverted },
      "icon"
    )

    tag.i(class: classes)
  end
end
