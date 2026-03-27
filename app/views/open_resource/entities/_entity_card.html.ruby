Link(href: entity_path(resource_name: entity.resource&.name || params[:resource_name], id: entity.id)) {
  Wrapper(html_class: "entity-card") {
    Wrapper(html_class: "entity-card-title") { text entity.display_name }
    Wrapper(html_class: "entity-card-meta") {
      text entity.created_at&.strftime("%Y-%m-%d %H:%M")
    }
  }
}
