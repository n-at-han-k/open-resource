# frozen_string_literal: true

# Site — base site wrapper with Fomantic-UI site module.
#
# Wraps content in a container that initializes the Fomantic-UI site module
# via the fui-site Stimulus controller.

class SiteComponent < Component
  def to_s
    tag.div(data: { controller: "fui-site" }) { @content }
  end
end
