# frozen_string_literal: true

# Table — data tables with column accumulator pattern.
#
# Usage:
#   Table(striped: true, rows: @users) { |c|
#     c.column(:name, heading: "Name") { |user|
#       Text(weight: :bold) { text user.name }
#     }
#     c.column(:email) { |user|
#       Text(color: :grey) { text user.email }
#     }
#   }
#
# Or with manual content:
#   Table(celled: true) { |c|
#     c.header {
#       TableRow {
#         TableCell(heading: true) { text "Name" }
#         TableCell(heading: true) { text "Age" }
#       }
#     }
#     TableRow {
#       TableCell { text "Alice" }
#       TableCell { text "30" }
#     }
#   }

class TableComponent < Component
  attribute :rows,        default: nil
  attribute :definition,  :boolean, default: false
  attribute :structured,  :boolean, default: false
  attribute :single_line, :boolean, default: false
  attribute :fixed,       :boolean, default: false
  attribute :selectable,  :boolean, default: false
  attribute :striped,     :boolean, default: false
  attribute :sortable,    :boolean, default: false
  attribute :celled,      :boolean, default: false
  attribute :basic,       :string,  default: nil
  attribute :compact,     :string,  default: nil
  attribute :padded,      :string,  default: nil
  attribute :collapsing,  :boolean, default: false
  attribute :inverted,    :boolean, default: false
  attribute :color,       :string,  default: nil
  attribute :size,        :string,  default: nil
  attribute :unstackable, :boolean, default: false
  attribute :stackable,   :boolean, default: false
  attribute :attached,    :string,  default: nil

  slot :header
  slot :footer

  def columns
    @columns ||= []
  end

  def column(key, heading: key.to_s.titleize, &block)
    columns << { key: key, heading: heading, block: block }
  end

  def to_s
    classes = class_names(
      "ui",
      size,
      color,
      basic_class,
      compact_class,
      padded_class,
      attached_class,
      { "definition" => definition,
        "structured" => structured,
        "single line" => single_line,
        "fixed" => fixed,
        "selectable" => selectable,
        "striped" => striped,
        "sortable" => sortable,
        "celled" => celled,
        "collapsing" => collapsing,
        "inverted" => inverted,
        "unstackable" => unstackable,
        "stackable" => stackable },
      "table"
    )

    if columns.any? && rows
      column_table(classes)
    else
      manual_table(classes)
    end
  end

  private

  def column_table(classes)
    head_cells = columns.map { |col| tag.th { col[:heading] } }

    body_rows = Array(rows).map { |row|
      cells = columns.map { |col|
        cell_content = col[:block]
          .then { |b| b && @view_context.capture(row, &b) }
          .then { |c| c || ERB::Util.html_escape(row.public_send(col[:key]).to_s) }
        tag.td { cell_content }
      }
      tag.tr { safe_join(cells) }
    }

    footer_el = @slots[:footer] ? tag.tfoot { @slots[:footer] } : nil

    tag.table(class: classes) {
      safe_join([
        tag.thead { tag.tr { safe_join(head_cells) } },
        tag.tbody { safe_join(body_rows) },
        footer_el
      ])
    }
  end

  def manual_table(classes)
    header_el = @slots[:header] ? tag.thead { @slots[:header] } : nil
    footer_el = @slots[:footer] ? tag.tfoot { @slots[:footer] } : nil
    body_el = @content.presence ? tag.tbody { @content } : nil

    tag.table(class: classes) {
      safe_join([ header_el, body_el, footer_el ])
    }
  end

  def basic_class
    case basic
    when "very" then "very basic"
    when "true", true then "basic"
    when String then "#{basic} basic"
    end
  end

  def compact_class
    case compact
    when "very" then "very compact"
    when "true", true then "compact"
    when String then "#{compact} compact"
    end
  end

  def attached_class
    case attached
    when "top" then "top attached"
    when "bottom" then "bottom attached"
    when "" then "attached"
    when String then "#{attached} attached"
    end
  end

  def padded_class
    case padded
    when "very" then "very padded"
    when "true", true then "padded"
    when String then "#{padded} padded"
    end
  end
end
