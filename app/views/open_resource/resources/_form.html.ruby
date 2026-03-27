Segment {
  text capture {
    form_with(model: resource, url: resource.persisted? ? resource_path(resource) : resources_path, class: "ui form") do |f|
      if resource.errors.any?
        concat render(MessageComponent.new(color: :red)) {
          safe_join(resource.errors.full_messages.map { |msg| content_tag(:p, msg) })
        }
      end

      concat content_tag(:div, class: "field#{" error" if resource.errors[:name].any?}") {
        safe_join([
          f.label(:name),
          f.text_field(:name, placeholder: "e.g. post, author, product")
        ])
      }

      concat content_tag(:div, class: "field") {
        safe_join([f.label(:label), f.text_field(:label, placeholder: "Human-readable label (optional)")])
      }

      concat content_tag(:div, class: "field") {
        safe_join([f.label(:description), f.text_area(:description, rows: 3, placeholder: "Description (optional)")])
      }

      concat content_tag(:div, class: "two fields") {
        safe_join([
          content_tag(:div, class: "field") {
            safe_join([f.label(:icon), f.text_field(:icon, placeholder: "Fomantic icon name (optional)")])
          },
          content_tag(:div, class: "field") {
            safe_join([f.label(:per_page), f.number_field(:per_page, value: resource.per_page || 25)])
          }
        ])
      }

      concat content_tag(:div, class: "ui divider")

      concat render(ButtonComponent.new(variant: :primary, type: :submit)) {
        resource.persisted? ? "Update Resource" : "Create Resource"
      }
      concat " "
      concat render(ButtonComponent.new(href: resource.persisted? ? resource_path(resource) : resources_path)) {
        "Cancel"
      }
    end
  }
}
