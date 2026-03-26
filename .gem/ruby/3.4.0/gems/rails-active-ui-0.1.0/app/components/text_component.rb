# frozen_string_literal: true

# Text — inline text container. Merges the holy spec primitive with Fomantic-UI text.
#
# Usage:
#   Text { text "Hello" }
#   Text(size: :sm, style: :secondary) { text "Muted text" }
#   Text(weight: :bold, color: :red) { text "Important" }

class TextComponent < Component
  attribute :style,  :string, default: nil
  attribute :size,   :string, default: nil
  attribute :weight, :string, default: nil
  attribute :color,  :string, default: nil

  def to_s
    has_fui_class = color || size_fui

    fui_classes = if has_fui_class
      class_names(
        "ui",
        color,
        size_fui,
        "text"
      )
    end

    style_parts = [
      (style && "text-#{style}"),
      (size_css && "font-size:#{size_css}"),
      (weight && "font-weight:#{weight_value}")
    ].compact

    opts = {}
    opts[:class] = fui_classes if fui_classes
    opts[:style] = style_parts.join(";") if style_parts.any?

    tag.span(**opts) { @content }
  end

  private

  # Fomantic-UI text size classes
  def size_fui
    case size
    when "mini", "tiny", "small", "medium", "large", "big", "huge", "massive"
      size
    end
  end

  # CSS font-size for spec-style sizes (sm, xs, etc.)
  def size_css
    case size
    when "xs"  then "0.75rem"
    when "sm"  then "0.875rem"
    when "lg"  then "1.125rem"
    when "xl"  then "1.25rem"
    when "2xl" then "1.5rem"
    end
  end

  def weight_value
    case weight.to_s
    when "light"    then "300"
    when "normal"   then "400"
    when "medium"   then "500"
    when "semibold" then "600"
    when "bold"     then "700"
    when "heavy"    then "900"
    else weight
    end
  end
end
