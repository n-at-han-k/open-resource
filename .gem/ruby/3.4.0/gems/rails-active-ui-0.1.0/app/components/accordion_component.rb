# frozen_string_literal: true

# Accordion — collapsible content panels.
#
# Usage:
#   Accordion(styled: true) {
#     MenuItem(header: true) {
#       Icon(name: "dropdown")
#       text " Section"
#     }
#     text "Panel content"
#   }

class AccordionComponent < Component
  attribute :styled,   :boolean, default: false
  attribute :fluid,    :boolean, default: false
  attribute :inverted, :boolean, default: false
  attribute :exclusive, :boolean, default: true
  attribute :collapsible, :boolean, default: true

  def to_s
    classes = class_names(
      "ui",
      { "styled" => styled, "fluid" => fluid, "inverted" => inverted },
      "accordion"
    )

    data = { controller: "fui-accordion" }
    data[:fui_accordion_exclusive_value] = "false" unless exclusive
    data[:fui_accordion_collapsible_value] = "false" unless collapsible

    tag.div(class: classes, data: data) { @content }
  end
end
