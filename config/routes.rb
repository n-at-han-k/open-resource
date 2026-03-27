# frozen_string_literal: true

OpenResource::Engine.routes.draw do
  # ── API ──────────────────────────────────────────────────────────────
  scope module: :api do
    post "/graphql", to: "graphql#execute"

    if defined?(GraphiQL::Rails::Engine)
      mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
    end

    get "/api/schema",            to: "schema#index"
    get "/api/schema/:resource",  to: "schema#show"

    resources :resources, path: "/api/resources/:resource_name",
              only: [ :index, :show, :create, :update, :destroy ],
              param: :id,
              as: :api_resources,
              constraints: { id: /[^\/]+/ }
  end

  # ── HTML UI ──────────────────────────────────────────────────────────
  resources :resources do
    resources :attributes, except: [ :index ]
  end
  resources :associations, except: [ :show ]

  get "/data/:resource_name",     to: "entities#index", as: :entities
  get "/data/:resource_name/:id", to: "entities#show",  as: :entity

  root to: "resources#index"
end
