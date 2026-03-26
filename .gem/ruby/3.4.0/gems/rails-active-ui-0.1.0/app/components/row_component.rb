# frozen_string_literal: true

# Row — grid row with optional column count.
#
# Usage:
#   Grid {
#     Row(columns: 3) {
#       Column { text "A" }
#       Column { text "B" }
#       Column { text "C" }
#     }
#   }

class RowComponent < Component
  NUMBERS = %w[one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen].freeze

  attribute :columns, :integer, default: nil
  attribute :centered, :boolean, default: false
  attribute :stretched, :boolean, default: false
  attribute :equal_width, :boolean, default: false
  attribute :only,     :string,  default: nil
  attribute :aligned,  :string,  default: nil

  def to_s
    col_word = columns && columns.between?(1, 16) ? NUMBERS[columns - 1] : nil

    classes = class_names(
      col_word && "#{col_word} column",
      only && "#{only} only",
      aligned && "#{aligned} aligned",
      { "centered" => centered,
        "stretched" => stretched,
        "equal width" => equal_width },
      "row"
    )

    tag.div(class: classes) { @content }
  end
end
