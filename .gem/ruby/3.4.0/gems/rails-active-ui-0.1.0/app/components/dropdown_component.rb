# frozen_string_literal: true

# Dropdown — selection dropdowns with search and multi-select.
#
# Usage:
#   Dropdown(selection: true, placeholder: "Select...", name: "country") {
#     MenuItem { text "United States" }
#     MenuItem { text "Canada" }
#   }

class DropdownComponent < Component
  attribute :selection,     :boolean, default: false
  attribute :search,        :boolean, default: false
  attribute :multiple,      :boolean, default: false
  attribute :clearable,     :boolean, default: false
  attribute :fluid,         :boolean, default: false
  attribute :placeholder,   :string,  default: nil
  attribute :name,          :string,  default: nil
  attribute :default_value, :string,  default: nil
  attribute :pointing,      :string,  default: nil
  attribute :compact,       :boolean, default: false
  attribute :scrolling,     :boolean, default: false
  attribute :inline,        :boolean, default: false
  attribute :floating,      :boolean, default: false
  attribute :button,        :boolean, default: false
  attribute :labeled,       :boolean, default: false
  attribute :loading,       :boolean, default: false
  attribute :disabled,      :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      pointing && "#{pointing} pointing",
      { "selection" => selection, "search" => search, "multiple" => multiple,
        "clearable" => clearable, "fluid" => fluid, "compact" => compact,
        "scrolling" => scrolling, "inline" => inline, "floating" => floating,
        "button" => button, "labeled" => labeled, "loading" => loading,
        "disabled" => disabled },
      "dropdown"
    )

    data = { controller: "fui-dropdown" }
    data[:fui_dropdown_clearable_value] = "true" if clearable
    data[:fui_dropdown_placeholder_value] = placeholder if placeholder

    hidden_opts = { type: "hidden", value: default_value || "" }
    hidden_opts[:name] = name if name

    search_el = search ? tag.input(class: "search") : nil
    text_el = tag.div(class: "default text") { placeholder || "" }
    menu_el = tag.div(class: "menu") { @content }

    tag.div(class: classes, data: data) {
      safe_join([
        tag.input(**hidden_opts),
        search_el,
        text_el,
        tag.i(class: "dropdown icon"),
        menu_el
      ])
    }
  end
end
