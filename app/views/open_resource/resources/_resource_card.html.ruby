Link(href: resource_path(resource)) {
  Wrapper(html_class: "resource-card") {
    Wrapper(html_class: "resource-card-title") { text resource.display_label }
    Wrapper(html_class: "resource-card-meta") { text resource.name }
    Wrapper(html_class: "resource-card-meta") {
      text "#{resource.resource_attributes.count} attributes"
    }
  }
}
