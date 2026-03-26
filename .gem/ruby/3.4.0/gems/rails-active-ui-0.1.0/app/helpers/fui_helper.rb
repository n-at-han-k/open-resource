# frozen_string_literal: true

# Provides the fui_javascript_tags helper for loading jQuery and
# Fomantic-UI component scripts in the correct order.
#
# Usage (in your application layout, before javascript_importmap_tags):
#
#   <%= fui_javascript_tags %>
#   <%= javascript_importmap_tags %>
#
# This emits <script> tags for jQuery and each Fomantic-UI component.
# The Stimulus bridge controllers are loaded separately via importmap.

module FuiHelper
  # Fomantic component scripts in load order.
  # site and transition must come first — other components depend on them.
  FOMANTIC_SCRIPTS = %w[
    site
    transition
    accordion
    api
    calendar
    checkbox
    dimmer
    dropdown
    embed
    flyout
    form
    modal
    nag
    popup
    progress
    rating
    search
    shape
    sidebar
    slider
    state
    sticky
    tab
    toast
    visibility
  ].freeze

  def fui_javascript_tags
    tags = []
    tags << javascript_include_tag("jquery")
    FOMANTIC_SCRIPTS.each do |name|
      tags << javascript_include_tag(name)
    end
    safe_join(tags, "\n")
  end
end
