Header(size: :h2, dividing: true) {
  text @entity.display_name
  SubHeader { text "#{@resource.display_label} ##{@entity.id}" }
}

Segment {
  Button(href: entities_path(resource_name: @resource.name), icon: "arrow left") { text "Back to list" }
}

# -- Attributes --
Table(celled: true, definition: true) { |c|
  c.header {
    TableRow {
      TableCell(heading: true) { text "Attribute" }
      TableCell(heading: true) { text "Value" }
    }
  }
  @attributes.each do |attr|
    TableRow {
      TableCell { Header(size: :h5) { text attr.display_label } }
      TableCell { text @entity.send(attr.name).to_s }
    }
  end
}

# -- Belongs To Associations --
@child_assocs.each do |assoc|
  related = @entity.send(assoc.belongs_to_name)
  next unless related

  Segment {
    Header(size: :h4) { text assoc.belongs_to_name.titleize }
    text link_to(related.display_name, entity_path(resource_name: assoc.parent, id: related.id))
  }
end

# -- Has Many Associations --
@parent_assocs.each do |assoc|
  related = @entity.send(assoc.has_many_name)

  Segment {
    Header(size: :h4) { text assoc.has_many_name.titleize }

    if related.any?
      target_resource = OpenResource::Resource.find_by(name: assoc.child)
      target_attrs = target_resource&.resource_attributes&.order(position: :asc)&.limit(4) || []

      Table(celled: true, striped: true, rows: related) { |c|
        c.column(:id, heading: "ID") { |e|
          Link(href: entity_path(resource_name: assoc.child, id: e.id)) { text e.id.to_s }
        }
        target_attrs.each do |attr|
          c.column(attr.name.to_sym, heading: attr.display_label) { |e| text e.send(attr.name).to_s }
        end
      }
    else
      text "No #{assoc.has_many_name} found."
    end
  }
end
