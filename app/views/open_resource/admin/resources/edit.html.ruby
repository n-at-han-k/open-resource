Header(size: :h2, dividing: true) { text "Edit Resource: #{@resource.name}" }
text render("form", resource: @resource)
