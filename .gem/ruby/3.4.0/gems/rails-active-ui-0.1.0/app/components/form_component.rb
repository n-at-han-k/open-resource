# frozen_string_literal: true

# Form — form layout and validation with Stimulus controller.
#
# Usage:
#   Form(action: "/submit", method: :post) {
#     text '<div class="field"><label>Name</label><input type="text"></div>'.html_safe
#   }
#   Form(loading: true, size: :large) { ... }

class FormComponent < Component
  attribute :size,        :string,  default: nil
  attribute :loading,     :boolean, default: false
  attribute :success,     :boolean, default: false
  attribute :error,       :boolean, default: false
  attribute :warning,     :boolean, default: false
  attribute :inverted,    :boolean, default: false
  attribute :equal_width, :boolean, default: false
  attribute :action,      :string,  default: nil
  attribute :method_type, :string,  default: "post"
  attribute :reply,       :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      { "loading" => loading, "success" => success, "error" => error,
        "warning" => warning, "inverted" => inverted,
        "equal width" => equal_width, "reply" => reply },
      "form"
    )

    opts = { class: classes, data: { controller: "fui-form" } }
    opts[:action] = action if action
    opts[:method] = method_type if action

    tag.form(**opts) { @content }
  end
end
