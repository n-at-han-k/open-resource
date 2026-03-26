# frozen_string_literal: true

# Feed — activity/event feed.
#
# Usage:
#   Feed(size: :small) {
#     text '<div class="event">...</div>'.html_safe
#   }

class FeedComponent < Component
  attribute :size, :string, default: nil

  def to_s
    classes = class_names(
      "ui",
      size,
      "feed"
    )

    tag.div(class: classes) { @content }
  end
end
