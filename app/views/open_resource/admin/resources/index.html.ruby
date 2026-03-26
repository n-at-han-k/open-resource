Header(size: :h2, dividing: true) { text "Resources" }

Segment {
  Button(color: :green, icon: "plus", href: new_resource_path) { text "New Resource" }
}

text datatable(columns: ["Name", "Label", "Attributes", "Entities", "Actions"]) {
  safe_join(@resources.map { |resource|
    content_tag(:tr) {
      safe_join([
        content_tag(:td, link_to(resource.name, resource_path(resource))),
        content_tag(:td, resource.display_label),
        content_tag(:td, resource.resource_attributes.count),
        content_tag(:td, link_to(resource.entities.count, entities_path(resource_name: resource.name))),
        content_tag(:td) {
          safe_join([
            link_to("Edit", edit_resource_path(resource), class: "ui mini button"),
            " ",
            link_to("Data", entities_path(resource_name: resource.name), class: "ui mini teal button"),
            " ",
            button_to("Delete", resource_path(resource), method: :delete,
              class: "ui mini red button", style: "display:inline",
              data: { turbo_confirm: "Delete resource '#{resource.name}'?" })
          ])
        }
      ])
    }
  })
}
