# frozen_string_literal: true

# Menu — navigation menus.
#
# Usage:
#   Menu(pointing: true, secondary: true) {
#     MenuItem(href: "#", active: true) { text "Home" }
#     MenuItem(href: "#") { text "Messages" }
#   }

class MenuComponent < Component
  include Positionable
  include Attachable
  include Sizeable

  attribute :secondary,    :boolean, default: false
  attribute :pointing,     :boolean, default: false
  attribute :tabular,      :boolean, default: false
  attribute :vertical,     :boolean, default: false
  attribute :fixed,        :string,  default: nil
  attribute :inverted,     :boolean, default: false
  attribute :icon,         :boolean, default: false
  attribute :labeled_icon, :boolean, default: false
  attribute :compact,      :boolean, default: false
  attribute :fluid,        :boolean, default: false
  attribute :color,        :string,  default: nil
  attribute :stackable,    :boolean, default: false
  attribute :text,         :boolean, default: false
  attribute :pagination,   :boolean, default: false
  attribute :borderless,   :boolean, default: false
  attribute :items,        :integer, default: nil

  NUMBERS = %w[one two three four five six seven eight nine ten eleven twelve].freeze

  def to_s
    item_word = items && items.between?(1, 12) ? NUMBERS[items - 1] : nil

    classes = class_names(
      "ui",
      position,
      size,
      color,
      item_word && "#{item_word} item",
      fixed && "#{fixed} fixed",
      { "attached" => attached,
        "secondary" => secondary,
        "pointing" => pointing,
        "tabular" => tabular,
        "vertical" => vertical,
        "inverted" => inverted,
        "icon" => icon && !labeled_icon,
        "labeled icon" => labeled_icon,
        "compact" => compact,
        "fluid" => fluid,
        "stackable" => stackable,
        "text" => text,
        "pagination" => pagination,
        "borderless" => borderless },
      "menu"
    )

    tag.div(class: classes) { @content }
  end
end
