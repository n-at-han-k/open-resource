Header(size: :h2, dividing: true) {
  text @resource.display_label
  SubHeader { text @resource.name }
}

Segment { text @resource.description } if @resource.description.present?

Segment {
  Button(href: edit_resource_path(@resource), icon: "edit") { text "Edit Resource" }
  Button(color: :teal, href: entities_path(resource_name: @resource.name), icon: "database") { text "View Data" }
}

# -- Attributes --
Header(size: :h3, dividing: true) { text "Attributes" }

Button(color: :green, icon: "plus", size: :small, href: new_resource_attribute_path(@resource)) { text "Add Attribute" }

text datatable(columns: ["Pos", "Name", "Label", "Type", "Required", "Actions"], options: { order: [[0, "asc"]] }) {
  safe_join(@attributes.map { |attr|
    content_tag(:tr) {
      safe_join([
        content_tag(:td, attr.position),
        content_tag(:td, attr.name),
        content_tag(:td, attr.display_label),
        content_tag(:td) { render(LabelComponent.new(color: :blue)) { attr.field_type } },
        content_tag(:td) { attr.required ? render(LabelComponent.new(color: :red)) { "required" } : "" },
        content_tag(:td) {
          safe_join([
            link_to("Edit", edit_resource_attribute_path(@resource, attr), class: "ui mini button"),
            " ",
            button_to("Delete", resource_attribute_path(@resource, attr), method: :delete,
              class: "ui mini red button", style: "display:inline",
              data: { turbo_confirm: "Delete attribute '#{attr.name}'?" })
          ])
        }
      ])
    }
  })
}

# -- Associations --
Header(size: :h3, dividing: true) { text "Associations" }

if @child_assocs.any?
  Header(size: :h4) { text "Belongs To" }
  Table(celled: true, striped: true, rows: @child_assocs) { |c|
    c.column(:parent, heading: "Parent") { |a| Label(color: :teal) { text a.parent } }
    c.column(:method, heading: "Method") { |a| text "#{@resource.name}.#{a.belongs_to_name}" }
    c.column(:fk, heading: "FK") { |a| Label { text a.foreign_key_name } }
  }
end

if @parent_assocs.any?
  Header(size: :h4) { text "Has Many / Has One" }
  Table(celled: true, striped: true, rows: @parent_assocs) { |c|
    c.column(:child, heading: "Child") { |a| Label(color: :purple) { text a.child } }
    c.column(:type, heading: "Type") { |a|
      Label(color: a.has_many? ? :blue : :orange) { text a.has_many? ? "has_many" : "has_one" }
    }
    c.column(:method, heading: "Method") { |a| text "#{@resource.name}.#{a.has_many_name}" }
  }
end
