# frozen_string_literal: true

# Input — text input fields with icon, labeled, and action variants.
#
# Usage:
#   Input(placeholder: "Search...", icon: "search")
#   Input(icon: "users", icon_position: "left", placeholder: "Find users...")
#   Input(labeled: true) { text "$" }

class InputComponent < Component
  attribute :icon,          :string,  default: nil
  attribute :icon_position, :string,  default: "right"
  attribute :labeled,       :boolean, default: false
  attribute :action,        :boolean, default: false
  attribute :transparent,   :boolean, default: false
  attribute :fluid,         :boolean, default: false
  attribute :size,          :string,  default: nil
  attribute :loading,       :boolean, default: false
  attribute :disabled,      :boolean, default: false
  attribute :error,         :boolean, default: false
  attribute :inverted,      :boolean, default: false
  attribute :placeholder,   :string,  default: nil
  attribute :input_type,    :string,  default: "text"
  attribute :name,          :string,  default: nil
  attribute :value,         :string,  default: nil

  def to_s
    classes = class_names(
      "ui",
      size,
      { "left icon" => icon && icon_position == "left",
        "icon" => icon && icon_position != "left",
        "labeled" => labeled, "action" => action, "transparent" => transparent,
        "fluid" => fluid, "loading" => loading, "disabled" => disabled,
        "error" => error, "inverted" => inverted },
      "input"
    )

    input_opts = { type: input_type }
    input_opts[:placeholder] = placeholder if placeholder
    input_opts[:name] = name if name
    input_opts[:value] = value if value
    input_opts[:disabled] = "disabled" if disabled

    icon_el = icon ? tag.i(class: "#{icon} icon") : nil
    input_el = tag.input(**input_opts)

    tag.div(class: classes) {
      safe_join([ @content, input_el, icon_el ])
    }
  end
end
