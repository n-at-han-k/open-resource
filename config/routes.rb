# frozen_string_literal: true

OpenResource::Engine.routes.draw do
  # API endpoints
  get "/api/schema", to: "schema#index"
  get "/api/schema/:resource", to: "schema#show"

  resources :resources, path: "/api/resources/:resource_name",
           only: [:index, :show, :create, :update, :destroy],
           param: :id,
           as: :api_resources,
           controller: "resources",
           constraints: { id: /[^\/]+/ }

  # Admin UI
  scope module: :admin do
    resources :resources do
      resources :attributes, controller: "attributes", except: [:index]
    end
    resources :associations, except: [:show]
    get "/data/:resource_name", to: "entities#index", as: :entities
    get "/data/:resource_name/:id", to: "entities#show", as: :entity
  end

  root to: "admin/resources#index"
end
