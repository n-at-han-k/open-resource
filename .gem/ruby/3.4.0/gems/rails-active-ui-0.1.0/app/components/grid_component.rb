# frozen_string_literal: true

# Grid — responsive grid system.
#
# Usage:
#   Grid(columns: 3, stackable: true) {
#     Column { text "A" }
#     Column { text "B" }
#     Column { text "C" }
#   }

class GridComponent < Component
  NUMBERS = %w[one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen].freeze

  attribute :columns,     :integer, default: nil
  attribute :stackable,   :boolean, default: false
  attribute :doubling,    :boolean, default: false
  attribute :centered,    :boolean, default: false
  attribute :divided,     :string,  default: nil
  attribute :celled,      :string,  default: nil
  attribute :padded,      :string,  default: nil
  attribute :relaxed,     :string,  default: nil
  attribute :equal_width, :boolean, default: false
  attribute :reversed,    :string,  default: nil
  attribute :container,   :boolean, default: false
  attribute :internal,    :boolean, default: false
  attribute :inverted,   :boolean, default: false
  attribute :aligned,    :string,  default: nil

  def to_s
    col_word = columns && columns.between?(1, 16) ? NUMBERS[columns - 1] : nil

    classes = class_names(
      "ui",
      col_word && "#{col_word} column",
      aligned && "#{aligned} aligned",
      divided_class,
      celled_class,
      padded_class,
      relaxed_class,
      reversed && "#{reversed} reversed",
      { "stackable" => stackable, "doubling" => doubling, "centered" => centered,
        "equal width" => equal_width, "container" => container,
        "internally" => internal, "inverted" => inverted },
      "grid"
    )

    tag.div(class: classes) { @content }
  end

  private

  def divided_class
    case divided
    when "vertically" then "vertically divided"
    when "true", true then "divided"
    when String then "#{divided} divided"
    end
  end

  def celled_class
    case celled
    when "internally" then "internally celled"
    when "true", true then "celled"
    when String then "#{celled} celled"
    end
  end

  def padded_class
    case padded
    when "vertically" then "vertically padded"
    when "horizontally" then "horizontally padded"
    when "true", true then "padded"
    when String then "#{padded} padded"
    end
  end

  def relaxed_class
    case relaxed
    when "very" then "very relaxed"
    when "true", true then "relaxed"
    when String then "#{relaxed} relaxed"
    end
  end
end
