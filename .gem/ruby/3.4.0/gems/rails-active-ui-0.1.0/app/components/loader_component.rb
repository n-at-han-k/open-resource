# frozen_string_literal: true

# Loader — loading spinners.
#
# Usage:
#   Loader(active: true)
#   Loader(active: true, size: :large) { text "Loading..." }
#   Loader(inline: true, centered: true, active: true)

class LoaderComponent < Component
  attribute :active,        :boolean, default: false
  attribute :inline,        :boolean, default: false
  attribute :centered,      :boolean, default: false
  attribute :size,          :string,  default: nil
  attribute :inverted,      :boolean, default: false
  attribute :indeterminate, :boolean, default: false
  attribute :color,         :string,  default: nil
  attribute :disabled,      :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      color,
      { "active" => active, "disabled" => disabled, "inline" => inline,
        "centered" => centered, "inverted" => inverted,
        "indeterminate" => indeterminate, "text" => @content.present? },
      "loader"
    )

    tag.div(class: classes) { @content }
  end
end
