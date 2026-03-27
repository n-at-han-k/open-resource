Header(size: :h2, dividing: true) {
  text "Resources "
  Dropdown(inline: true, placeholder: current_layout == "list" ? "List" : "Table") {
    MenuItem(href: url_for(request.query_parameters.merge(layout_view: "table")), icon: "table") { text "Table" }
    MenuItem(href: url_for(request.query_parameters.merge(layout_view: "list")), icon: "list") { text "List" }
  }
}

if current_layout == "list"
  Partial("list_layout")
else
  Partial("table_layout")
end
