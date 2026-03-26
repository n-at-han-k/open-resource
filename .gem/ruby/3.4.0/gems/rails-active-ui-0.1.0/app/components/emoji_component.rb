# frozen_string_literal: true

# Emoji — renders a Fomantic-UI emoji by name.
#
# Usage:
#   Emoji(name: "smile")
#   Emoji(name: "thumbsup")

class EmojiComponent < Component
  attribute :name, :string, default: nil

  def to_s
    tag.em(class: "small", data: { emoji: ":#{name}:" })
  end
end
