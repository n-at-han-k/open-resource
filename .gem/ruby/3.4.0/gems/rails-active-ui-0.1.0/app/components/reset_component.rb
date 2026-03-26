# frozen_string_literal: true

# Reset — CSS reset/normalize.
#
# Fomantic-UI's reset is loaded via the asset pipeline (semantic.css).
# This component is a no-op marker for inventory completeness.

class ResetComponent < Component
  def to_s
    tag.comment("fomantic-ui reset loaded via asset pipeline")
  end
end
