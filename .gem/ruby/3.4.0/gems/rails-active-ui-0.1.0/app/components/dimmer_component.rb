# frozen_string_literal: true

# Dimmer — page/element overlay dimmer.
#
# Usage:
#   Dimmer(active: true) { text "Dimmed content" }
#   Dimmer(inverted: true, active: true) {
#     Loader(active: true) { text "Loading..." }
#   }

class DimmerComponent < Component
  attribute :active,   :boolean, default: false
  attribute :inverted, :boolean, default: false
  attribute :blurring, :boolean, default: false
  attribute :simple,   :boolean, default: false
  attribute :page,     :boolean, default: false

  def to_s
    classes = class_names(
      "ui",
      { "active" => active, "inverted" => inverted, "blurring" => blurring,
        "simple" => simple, "page" => page },
      "dimmer"
    )

    content_el = @content.present? ? tag.div(class: "content") { @content } : nil

    tag.div(class: classes, data: { controller: "fui-dimmer" }) { content_el }
  end
end
