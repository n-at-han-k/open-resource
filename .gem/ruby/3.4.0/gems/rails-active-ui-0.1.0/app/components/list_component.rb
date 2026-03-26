# frozen_string_literal: true

# List — ordered, unordered, and bulleted lists.
#
# Usage:
#   List(bulleted: true) { text "items..." }
#   List(divided: true, relaxed: true) { text "items..." }

class ListComponent < Component
  attribute :ordered,    :boolean, default: false
  attribute :bulleted,   :boolean, default: false
  attribute :divided,    :boolean, default: false
  attribute :relaxed,    :boolean, default: false
  attribute :animated,   :boolean, default: false
  attribute :horizontal, :boolean, default: false
  attribute :inverted,   :boolean, default: false
  attribute :size,       :string,  default: nil
  attribute :celled,     :boolean, default: false
  attribute :selection,  :boolean, default: false
  attribute :link,       :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      size,
      { "ordered" => ordered, "bulleted" => bulleted, "divided" => divided,
        "relaxed" => relaxed, "animated" => animated, "horizontal" => horizontal,
        "inverted" => inverted, "celled" => celled, "selection" => selection,
        "link" => link },
      "list"
    )

    if ordered
      tag.ol(class: classes) { @content }
    else
      tag.div(class: classes) { @content }
    end
  end
end
