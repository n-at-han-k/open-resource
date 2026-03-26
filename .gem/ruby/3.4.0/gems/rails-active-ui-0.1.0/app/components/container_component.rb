# frozen_string_literal: true

# Container — fixed-width page container.
#
# Usage:
#   Container { text "Page content" }
#   Container(text: true) { text "Narrower text container" }
#   Container(fluid: true) { text "Full-width" }

class ContainerComponent < Component
  attribute :text,  :boolean, default: false
  attribute :fluid, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      { "text" => text, "fluid" => fluid },
      "container"
    )

    tag.div(class: classes) { @content }
  end
end
