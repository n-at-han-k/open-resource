# frozen_string_literal: true

# Checkbox — checkboxes, radios, toggles, sliders.
#
# Usage:
#   Checkbox(label_text: "Accept terms", name: "terms")
#   Checkbox(type: :toggle, label_text: "Dark mode", checked: true)
#   Checkbox(type: :radio, label_text: "Option A", name: "choice", value: "a")

class CheckboxComponent < Component
  attribute :type,       :string,  default: "checkbox"
  attribute :label_text, :string,  default: nil
  attribute :name,       :string,  default: nil
  attribute :value,      :string,  default: nil
  attribute :checked,    :boolean, default: false
  attribute :disabled,   :boolean, default: false
  attribute :read_only,  :boolean, default: false
  attribute :fitted,     :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      (type unless type == "checkbox"),
      { "fitted" => fitted, "read-only" => read_only, "disabled" => disabled },
      "checkbox"
    )

    field_type = type == "radio" ? "radio" : "checkbox"
    input_opts = { type: field_type }
    input_opts[:name] = name if name
    input_opts[:value] = value if value
    input_opts[:checked] = "checked" if checked
    input_opts[:disabled] = "disabled" if disabled

    label_el = tag.label { label_text || "" }

    tag.div(class: classes, data: { controller: "fui-checkbox" }) {
      safe_join([ tag.input(**input_opts), label_el ])
    }
  end
end
