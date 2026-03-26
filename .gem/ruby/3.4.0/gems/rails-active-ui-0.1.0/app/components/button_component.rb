# frozen_string_literal: true

# Button — buttons in many styles.
#
# Usage:
#   Button(color: :green, icon: "checkmark") { text "Approve" }
#   Button(variant: :primary, size: :large, fluid: true) { text "Submit" }
#   Button(href: "/path", variant: :primary) { text "Go" }

class ButtonComponent < Component
  include Attachable
  include Sizeable

  attribute :color,    :string,  default: nil
  attribute :variant,  :string,  default: nil
  attribute :icon,     :string,  default: nil
  attribute :fluid,    :boolean, default: false
  attribute :disabled, :boolean, default: false
  attribute :loading,  :boolean, default: false
  attribute :animated, :string,  default: nil
  attribute :labeled,  :boolean, default: false
  attribute :href,     :string,  default: nil
  attribute :type,     :string,  default: "button"
  attribute :inverted, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      color,
      size,
      variant,
      animated && "animated #{animated unless animated == 'true'}".strip,
      { "fluid" => fluid, "disabled" => disabled, "loading" => loading,
        "inverted" => inverted, "attached" => attached,
        "labeled icon" => labeled && icon,
        "icon" => icon && !labeled && !@content },
      "button"
    )

    icon_el = icon ? tag.i(class: "#{icon} icon") : nil
    content = safe_join([ icon_el, @content ])

    if href
      tag.a(class: classes, href: href) { content }
    else
      tag.button(class: classes, type: type) { content }
    end
  end
end
