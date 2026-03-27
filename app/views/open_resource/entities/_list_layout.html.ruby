ResourceListBlock(
  search_url:        entities_path(resource_name: @resource.name),
  search_query:      @search_attribute ? @q : nil,
  search_predicate:  @search_attribute ? "properties_#{@search_attribute.name}_cont" : nil,
  search_placeholder: @search_attribute ? "Search #{@search_attribute.display_label}\u2026" : nil,
  resources:         @entities,
  item_partial:      "open_resource/entities/entity_card",
  item_local:        "entity",
  turbo_frame:       "entities-list"
)
