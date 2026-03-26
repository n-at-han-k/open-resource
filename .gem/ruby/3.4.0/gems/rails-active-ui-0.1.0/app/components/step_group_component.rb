# frozen_string_literal: true

# StepGroup — container for step indicators in multi-step workflows.
#
# Usage:
#   StepGroup(ordered: true) {
#     Step(active: true, title: "Shipping", description: "Choose your shipping options")
#     Step(title: "Billing", description: "Enter billing information")
#     Step(disabled: true, title: "Confirm Order")
#   }

class StepGroupComponent < Component
  attribute :ordered,     :boolean, default: false
  attribute :vertical,    :boolean, default: false
  attribute :fluid,       :boolean, default: false
  attribute :attached,    :string,  default: nil
  attribute :unstackable, :boolean, default: false
  attribute :size,        :string,  default: nil
  attribute :stackable,   :boolean, default: false
  attribute :circular,    :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      attached && "#{attached} attached",
      { "ordered" => ordered,
        "vertical" => vertical,
        "fluid" => fluid,
        "unstackable" => unstackable,
        "stackable" => stackable,
        "circular" => circular },
      "steps"
    )

    tag.div(class: classes) { @content }
  end
end
