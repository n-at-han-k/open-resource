# frozen_string_literal: true

# Calendar — date/time picker.
#
# Usage:
#   Calendar(type: :date, name: "start_date")
#   Calendar(type: :datetime, format: "YYYY-MM-DD HH:mm")

class CalendarComponent < Component
  attribute :type,     :string, default: "date"
  attribute :name,     :string, default: nil
  attribute :format,   :string, default: nil
  attribute :min_date, :string, default: nil
  attribute :max_date, :string, default: nil

  def to_s
    data = { controller: "fui-calendar", fui_calendar_type_value: type }
    data[:fui_calendar_format_value] = format if format
    data[:fui_calendar_min_date_value] = min_date if min_date
    data[:fui_calendar_max_date_value] = max_date if max_date

    input_opts = { type: "text", placeholder: type }
    input_opts[:name] = name if name

    tag.div(class: "ui calendar", data: data) {
      tag.div(class: "ui input left icon") {
        safe_join([
          tag.i(class: "calendar icon"),
          tag.input(**input_opts)
        ])
      }
    }
  end
end
