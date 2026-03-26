# frozen_string_literal: true

# Shape — 3D CSS shape transformations.
#
# Usage:
#   Shape(type: :cube) {
#     text '<div class="sides">'.html_safe
#     text '<div class="side active">Side 1</div>'.html_safe
#     text '<div class="side">Side 2</div>'.html_safe
#     text '</div>'.html_safe
#   }

class ShapeComponent < Component
  attribute :type, :string, default: nil

  def to_s
    classes = class_names(
      "ui",
      type,
      "shape"
    )

    tag.div(class: classes, data: { controller: "fui-shape" }) { @content }
  end
end
