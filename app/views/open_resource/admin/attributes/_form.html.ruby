Segment {
  text capture {
    form_with(model: attribute, url: attribute.persisted? ? resource_attribute_path(resource, attribute) : resource_attributes_path(resource), class: "ui form") do |f|
      if attribute.errors.any?
        concat render(MessageComponent.new(color: :red)) {
          safe_join(attribute.errors.full_messages.map { |msg| content_tag(:p, msg) })
        }
      end

      concat content_tag(:div, class: "two fields") {
        safe_join([
          content_tag(:div, class: "field#{" error" if attribute.errors[:name].any?}") {
            safe_join([f.label(:name), f.text_field(:name, placeholder: "e.g. title, email, price")])
          },
          content_tag(:div, class: "field") {
            safe_join([f.label(:label), f.text_field(:label, placeholder: "Display label (optional)")])
          }
        ])
      }

      concat content_tag(:div, class: "two fields") {
        safe_join([
          content_tag(:div, class: "field#{" error" if attribute.errors[:field_type].any?}") {
            safe_join([
              f.label(:field_type, "Type"),
              f.select(:field_type, OpenResource::ResourceAttribute::FIELD_TYPES.map { |t| [t.titleize, t] }, {}, class: "ui dropdown")
            ])
          },
          content_tag(:div, class: "field") {
            safe_join([f.label(:position), f.number_field(:position, value: attribute.position || 0)])
          }
        ])
      }

      concat content_tag(:div, class: "field") {
        safe_join([f.label(:default_value), f.text_field(:default_value, placeholder: "Default value (optional)")])
      }

      concat content_tag(:div, class: "ui divider")

      concat content_tag(:div, class: "inline fields") {
        safe_join([
          content_tag(:div, class: "field") {
            content_tag(:div, class: "ui checkbox") { safe_join([f.check_box(:required), f.label(:required)]) }
          },
          content_tag(:div, class: "field") {
            content_tag(:div, class: "ui checkbox") { safe_join([f.check_box(:filterable), f.label(:filterable)]) }
          },
          content_tag(:div, class: "field") {
            content_tag(:div, class: "ui checkbox") { safe_join([f.check_box(:sortable), f.label(:sortable)]) }
          },
          content_tag(:div, class: "field") {
            content_tag(:div, class: "ui checkbox") { safe_join([f.check_box(:index_visible, {}, true, false), f.label(:index_visible, "Show on index")]) }
          },
          content_tag(:div, class: "field") {
            content_tag(:div, class: "ui checkbox") { safe_join([f.check_box(:form_visible, {}, true, false), f.label(:form_visible, "Show on form")]) }
          }
        ])
      }

      concat content_tag(:div, class: "ui divider")

      concat render(ButtonComponent.new(variant: :primary, type: :submit)) {
        attribute.persisted? ? "Update Attribute" : "Create Attribute"
      }
      concat " "
      concat render(ButtonComponent.new(href: resource_path(resource))) { "Cancel" }
    end
  }
}
