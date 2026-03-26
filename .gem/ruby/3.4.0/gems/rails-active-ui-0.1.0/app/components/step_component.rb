# frozen_string_literal: true

# Step — individual step within a StepGroup.
#
# Usage:
#   StepGroup {
#     Step(active: true, icon: "truck", title: "Shipping", description: "Choose shipping")
#     Step(title: "Billing", description: "Enter billing info")
#     Step(disabled: true, title: "Confirm Order")
#   }
#
#   StepGroup {
#     Step(completed: true) {
#       text "Custom content"
#     }
#   }

class StepComponent < Component
  attribute :active,      :boolean, default: false
  attribute :completed,   :boolean, default: false
  attribute :disabled,    :boolean, default: false
  attribute :icon,        :string,  default: nil
  attribute :title,       :string,  default: nil
  attribute :description, :string,  default: nil
  attribute :href,        :string,  default: nil

  def to_s
    classes = class_names(
      { "active" => active, "completed" => completed, "disabled" => disabled },
      "step"
    )

    icon_el = icon ? tag.i(class: "#{icon} icon") : nil

    content_parts = [
      (title ? tag.div(class: "title") { title } : nil),
      (description ? tag.div(class: "description") { description } : nil)
    ].compact

    content_el = if content_parts.any?
      tag.div(class: "content") { safe_join(content_parts) }
    end

    inner = if @content.present?
      @content
    else
      safe_join([ icon_el, content_el ])
    end

    if href
      tag.a(class: classes, href: href) { inner }
    else
      tag.div(class: classes) { inner }
    end
  end
end
