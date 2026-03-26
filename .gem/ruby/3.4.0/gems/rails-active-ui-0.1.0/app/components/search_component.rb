# frozen_string_literal: true

# Search — search component with local/remote data.
#
# Usage:
#   Search(placeholder: "Search...", name: "q")
#   Search(category: true, fluid: true, size: :large)

class SearchComponent < Component
  attribute :category,       :boolean, default: false
  attribute :placeholder,    :string,  default: "Search..."
  attribute :min_characters, :integer, default: 1
  attribute :fluid,          :boolean, default: false
  attribute :size,           :string,  default: nil
  attribute :name,           :string,  default: nil
  attribute :url,            :string,  default: nil
  attribute :aligned,        :string,  default: nil

  def to_s
    classes = class_names(
      "ui",
      size,
      aligned && "#{aligned} aligned",
      { "category" => category,
        "fluid" => fluid },
      "search"
    )

    data = { controller: "fui-search" }
    data[:fui_search_url_value] = url if url

    input_opts = { class: "prompt", type: "text", placeholder: placeholder }
    input_opts[:name] = name if name

    input_wrapper = tag.div(class: "ui icon input") {
      safe_join([ tag.input(**input_opts), tag.i(class: "search icon") ])
    }
    results_el = tag.div(class: "results")

    tag.div(class: classes, data: data) {
      safe_join([ input_wrapper, results_el, @content ])
    }
  end
end
