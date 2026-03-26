# frozen_string_literal: true

# TableRow — a table row.
#
# Usage:
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

class TableRowComponent < Component
  attribute :active,   :boolean, default: false
  attribute :positive, :boolean, default: false
  attribute :negative, :boolean, default: false
  attribute :warning,  :boolean, default: false
  attribute :error,    :boolean, default: false
  attribute :disabled, :boolean, default: false

  def to_s
    classes = [
      ("active" if active),
      ("positive" if positive),
      ("negative" if negative),
      ("warning" if warning),
      ("error" if error),
      ("disabled" if disabled)
    ].compact

    if classes.any?
      tag.tr(class: classes.join(" ")) { @content }
    else
      tag.tr { @content }
    end
  end
end
