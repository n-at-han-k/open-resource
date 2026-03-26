# frozen_string_literal: true

module OpenResource
  module AdminHelper
    # Renders a DataTables-powered table via Stimulus controller.
    #
    #   <%= datatable(columns: ["ID", "Name", "Type"], options: { pageLength: 50 }) do %>
    #     <% @records.each do |record| %>
    #       <tr>
    #         <td><%= record.id %></td>
    #         <td><%= record.name %></td>
    #       </tr>
    #     <% end %>
    #   <% end %>
    #
    def datatable(columns: [], options: {}, &block)
      options_json = options.to_json

      content_tag(:div,
        data: {
          controller: "open-resource--datatable",
          "open-resource--datatable-options-value": options_json
        }
      ) do
        content_tag(:table, class: "ui celled striped table display", style: "width:100%") do
          thead = content_tag(:thead) do
            content_tag(:tr) do
              safe_join(columns.map { |col| content_tag(:th, col) })
            end
          end
          tbody = content_tag(:tbody, &block)
          thead + tbody
        end
      end
    end
  end
end
