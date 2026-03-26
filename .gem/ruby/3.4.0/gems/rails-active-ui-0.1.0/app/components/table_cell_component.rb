# frozen_string_literal: true

# TableCell — a table cell (td or th).
#
# Usage:
#   TableRow {
#     TableCell { text "Data" }
#     TableCell(aligned: "right", collapsing: true) { text "10 hours ago" }
#     TableCell(heading: true, colspan: 3) { text "Section" }
#   }

class TableCellComponent < Component
  attribute :heading,    :boolean, default: false
  attribute :aligned,    :string,  default: nil
  attribute :collapsing, :boolean, default: false
  attribute :single_line, :boolean, default: false
  attribute :positive,   :boolean, default: false
  attribute :negative,   :boolean, default: false
  attribute :warning,    :boolean, default: false
  attribute :error,      :boolean, default: false
  attribute :active,     :boolean, default: false
  attribute :disabled,   :boolean, default: false
  attribute :selectable, :boolean, default: false
  attribute :color,      :string,  default: nil
  attribute :width,      :integer, default: nil
  attribute :colspan,    :integer, default: nil
  attribute :rowspan,    :integer, default: nil

  NUMBERS = %w[one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen].freeze

  def to_s
    width_word = width && width.between?(1, 16) ? NUMBERS[width - 1] : nil

    classes = [
      (aligned && "#{aligned} aligned"),
      ("collapsing" if collapsing),
      ("single line" if single_line),
      ("positive" if positive),
      ("negative" if negative),
      ("warning" if warning),
      ("error" if error),
      ("active" if active),
      ("disabled" if disabled),
      ("selectable" if selectable),
      color,
      (width_word && "#{width_word} wide")
    ].compact

    opts = {}
    opts[:class] = classes.join(" ") if classes.any?
    opts[:colspan] = colspan if colspan
    opts[:rowspan] = rowspan if rowspan

    if heading
      tag.th(**opts) { @content }
    else
      tag.td(**opts) { @content }
    end
  end
end
