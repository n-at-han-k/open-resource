Header(size: :h2, dividing: true) { text "Associations" }

Segment {
  Button(color: :green, icon: "plus", href: new_association_path) { text "New Association" }
}

text datatable(columns: ["Child", "Parent", "Type", "Methods", "Name Override", "Actions"]) {
  safe_join(@associations.map { |assoc|
    content_tag(:tr) {
      safe_join([
        content_tag(:td) { render(LabelComponent.new(color: :purple)) { assoc.child } },
        content_tag(:td) { render(LabelComponent.new(color: :teal)) { assoc.parent } },
        content_tag(:td) {
          render(LabelComponent.new(color: assoc.has_many? ? :blue : :orange)) {
            assoc.has_many? ? "has_many" : "has_one"
          }
        },
        content_tag(:td, "#{assoc.child}.#{assoc.belongs_to_name} \u2194 #{assoc.parent}.#{assoc.has_many_name}"),
        content_tag(:td, assoc.name.presence || "-"),
        content_tag(:td) {
          safe_join([
            link_to("Edit", edit_association_path(assoc), class: "ui mini button"),
            " ",
            button_to("Delete", association_path(assoc), method: :delete,
              class: "ui mini red button", style: "display:inline",
              data: { turbo_confirm: "Delete this association?" })
          ])
        }
      ])
    }
  })
}
