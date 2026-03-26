Header(size: :h2, dividing: true) { text "Edit Attribute: #{@attribute.name}" }
text render("form", resource: @resource, attribute: @attribute)
