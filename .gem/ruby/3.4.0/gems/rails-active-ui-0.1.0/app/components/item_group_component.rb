# frozen_string_literal: true

# ItemGroup — container for grouped content items.
#
# Usage:
#   ItemGroup(divided: true, relaxed: true) {
#     Item { |c|
#       c.image { Image(src: "photo.jpg", size: "small") }
#       c.header { text "Title" }
#       c.description { text "Description" }
#     }
#   }

class ItemGroupComponent < Component
  attribute :divided,     :boolean, default: false
  attribute :relaxed,     :boolean, default: false
  attribute :link,        :boolean, default: false
  attribute :unstackable, :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      { "divided" => divided, "relaxed" => relaxed,
        "link" => link, "unstackable" => unstackable },
      "items"
    )

    tag.div(class: classes) { @content }
  end
end
