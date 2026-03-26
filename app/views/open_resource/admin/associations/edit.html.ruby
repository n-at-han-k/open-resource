Header(size: :h2, dividing: true) { text "Edit Association" }
text render("form", association: @association, resources: @resources)
