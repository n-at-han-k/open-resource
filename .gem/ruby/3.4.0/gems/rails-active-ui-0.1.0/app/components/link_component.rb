# frozen_string_literal: true

# Link — anchor element.
#
# Usage:
#   Link(href: "/about") { text "About Us" }
#   Link(href: "/help", target: "_blank") { text "Help" }

class LinkComponent < Component
  attribute :href,     :string,  default: "#"
  attribute :target,   :string,  default: nil
  attribute :rel,      :string,  default: nil
  attribute :css_class, :string, default: nil

  def to_s
    opts = { href: href }
    opts[:class] = css_class if css_class
    opts[:target] = target if target
    opts[:rel] = rel if rel

    tag.a(**opts) { @content }
  end
end
