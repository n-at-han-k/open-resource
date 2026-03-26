Segment {
  text capture {
    form_with(model: association, url: association.persisted? ? association_path(association) : associations_path, class: "ui form") do |f|
      if association.errors.any?
        concat render(MessageComponent.new(color: :red)) {
          safe_join(association.errors.full_messages.map { |msg| content_tag(:p, msg) })
        }
      end

      concat content_tag(:div, class: "two fields") {
        safe_join([
          content_tag(:div, class: "field#{" error" if association.errors[:child].any?}") {
            safe_join([
              f.label(:child, "Child Resource (belongs_to side)"),
              f.select(:child, resources.map { |r| [r.display_label, r.name] }, { include_blank: "Select resource..." }, class: "ui dropdown")
            ])
          },
          content_tag(:div, class: "field#{" error" if association.errors[:parent].any?}") {
            safe_join([
              f.label(:parent, "Parent Resource (has_many side)"),
              f.select(:parent, resources.map { |r| [r.display_label, r.name] }, { include_blank: "Select resource..." }, class: "ui dropdown")
            ])
          }
        ])
      }

      concat content_tag(:div, class: "field") {
        content_tag(:div, class: "ui checkbox") {
          safe_join([f.check_box(:has_many), f.label(:has_many, "Has Many (uncheck for Has One)")])
        }
      }

      concat content_tag(:div, class: "field") {
        safe_join([
          f.label(:name, "Name Override (optional)"),
          f.text_field(:name, placeholder: "Override belongs_to method name (e.g. writer instead of author)")
        ])
      }

      if association.child.present? && association.parent.present?
        concat render(SegmentComponent.new(secondary: true)) {
          safe_join([
            render(HeaderComponent.new(size: :h4)) { "Preview" },
            content_tag(:p) {
              safe_join([
                content_tag(:strong, association.child),
                ".belongs_to :#{association.belongs_to_name} (FK: #{association.foreign_key_name})"
              ])
            },
            content_tag(:p) {
              safe_join([
                content_tag(:strong, association.parent),
                ".#{association.has_many? ? "has_many" : "has_one"} :#{association.has_many_name}"
              ])
            }
          ])
        }
      end

      concat content_tag(:div, class: "ui divider")

      concat render(ButtonComponent.new(variant: :primary, type: :submit)) {
        association.persisted? ? "Update Association" : "Create Association"
      }
      concat " "
      concat render(ButtonComponent.new(href: associations_path)) { "Cancel" }
    end
  }
}
