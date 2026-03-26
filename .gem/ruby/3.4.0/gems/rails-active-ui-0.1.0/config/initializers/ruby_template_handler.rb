# frozen_string_literal: true

# The Sacred Template Handler
#
# Registers .html.ruby as a template format. View files are pure Ruby —
# no angle brackets, no ERB sigils. All output flows through components
# and the `text` helper method into the output buffer.
#
# In development, templates are annotated with HTML comments and metadata
# so that browser dev tools can identify template boundaries.

ActionView::Template.register_template_handler :ruby, ->(template, source) {
  if Rails.env.development?
    meta = {
      path: template.short_identifier,
      virtual_path: template.virtual_path,
      format: template.format,
      variant: template.variant
    }.to_json.gsub('"', '\\"')

    <<~RUBY
      output_buffer << "<template data-view-meta='#{meta}'></template>\\n".html_safe
      output_buffer << "<!-- BEGIN #{template.short_identifier} -->\\n".html_safe
      #{source}
      output_buffer << "<!-- END #{template.short_identifier} -->\\n".html_safe
      output_buffer
    RUBY
  else
    "#{source}\noutput_buffer"
  end
}
