Segment {
  Button(href: resource_path(@resource), icon: "setting") { text "Resource Settings" }
}

columns = ["ID"] + @attributes.map(&:display_label) + ["Created"]

text datatable(columns: columns) {
  safe_join(@entities.map { |entity|
    content_tag(:tr) {
      cells = []
      cells << content_tag(:td, link_to(entity.id, entity_path(resource_name: @resource.name, id: entity.id)))
      @attributes.each do |attr|
        cells << content_tag(:td, entity.send(attr.name))
      end
      cells << content_tag(:td, entity.created_at&.strftime("%Y-%m-%d %H:%M"))
      safe_join(cells)
    }
  })
}
