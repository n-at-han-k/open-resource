Header(size: :h2, dividing: true) { text "New Attribute for #{@resource.display_label}" }
text render("form", resource: @resource, attribute: @attribute)
