ResourceListBlock(
  search_url:       resources_path,
  search_query:     @q,
  search_predicate: "name_cont",
  resources:        @resources,
  item_partial:     "open_resource/resources/resource_card",
  item_local:       "resource",
  new_path:         new_resource_path,
  turbo_frame:      "resources-list"
)
