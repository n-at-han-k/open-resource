# frozen_string_literal: true

# The Ancestral Component
#
# All components descend from this class. It provides:
# - ActiveModel::Attributes for declarative attribute definitions
# - Named slots via the `slot` class macro
# - The `render_in` contract: block capture, HTML safety, dev annotations
#
# See: specs/the-holy-view-spec.md, specs/the-holy-slot-spec.md

class Component
  include ActiveModel::Model
  include ActiveModel::Attributes

  class_attribute :slot_names, default: []

  def self.default(**overrides)
    overrides.each do |name, value|
      type = attribute_types.fetch(name.to_s).type
      attribute name, type, default: value
    end
  end

  def self.slot(name)
    self.slot_names = slot_names + [ name ]

    define_method(name) { |&block|
      @slots[name] = @view_context.capture(&block)
    }
  end

  def render_in(context, &block)
    @view_context = context
    @slots = {}
    @content = context.capture(self, &block) if block
    @content = ERB::Util.html_escape(@content) unless @content.nil? || @content.html_safe?

    if Rails.env.development?
      "<!-- BEGIN #{self.class.name} -->#{self}<!-- END #{self.class.name} -->".html_safe
    else
      to_s
    end
  end

  def to_s
    raise NotImplementedError
  end

  private

  def tag
    @view_context.tag
  end

  def safe_join(parts, sep = nil)
    @view_context.safe_join(parts.compact, sep)
  end

  def class_names(*args)
    @view_context.class_names(*args)
  end
end
