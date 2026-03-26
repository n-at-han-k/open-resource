# frozen_string_literal: true

# Tab — tab navigation with content panes.
#
# Usage:
#   Tab(active: true) { text "Tab pane content" }

class TabComponent < Component
  attribute :active, :boolean, default: false
  attribute :path,   :string,  default: nil

  def to_s
    classes = class_names(
      "ui",
      { "active" => active },
      "tab"
    )

    data = { controller: "fui-tab" }
    data[:tab] = path if path

    tag.div(class: classes, data: data) { @content }
  end
end
