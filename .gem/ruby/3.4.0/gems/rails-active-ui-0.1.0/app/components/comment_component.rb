# frozen_string_literal: true

# Comment — threaded comment display.
#
# Usage:
#   Comment { |c|
#     c.avatar { Image(src: "avatar.png") }
#     c.author { text "Matt" }
#     c.metadata { text "Today at 5:42PM" }
#     c.text_slot { text "Great post!" }
#     c.actions { text '<a class="reply">Reply</a>'.html_safe }
#   }

class CommentComponent < Component
  attribute :collapsed, :boolean, default: false
  attribute :threaded,  :boolean, default: false

  slot :avatar
  slot :author
  slot :metadata
  slot :text_slot
  slot :actions

  def to_s
    classes = class_names(
      { "collapsed" => collapsed },
      "comment"
    )

    avatar_el = @slots[:avatar] ? tag.a(class: "avatar") { @slots[:avatar] } : nil

    content_parts = [
      @slots[:author] ? tag.a(class: "author") { @slots[:author] } : nil,
      @slots[:metadata] ? tag.div(class: "metadata") { @slots[:metadata] } : nil,
      @slots[:text_slot] ? tag.div(class: "text") { @slots[:text_slot] } : nil,
      @slots[:actions] ? tag.div(class: "actions") { @slots[:actions] } : nil
    ].compact

    content_el = content_parts.any? ? tag.div(class: "content") { safe_join(content_parts) } : nil

    tag.div(class: classes) {
      safe_join([ avatar_el, content_el, @content.presence ])
    }
  end
end
