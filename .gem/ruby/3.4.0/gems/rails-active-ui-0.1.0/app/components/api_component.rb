# frozen_string_literal: true

# Api — AJAX request management wrapper.
#
# Usage:
#   Api(url: "/api/users", method_val: :get) {
#     Button { text "Load Users" }
#   }

class ApiComponent < Component
  attribute :url,           :string, default: nil
  attribute :method_val,    :string, default: "get"
  attribute :action_val,    :string, default: nil
  attribute :state_context, :string, default: nil

  def to_s
    data = { controller: "fui-api", fui_api_method_value: method_val }
    data[:fui_api_url_value] = url if url
    data[:fui_api_action_value] = action_val if action_val
    data[:fui_api_state_context_value] = state_context if state_context

    tag.div(data: data) { @content }
  end
end
