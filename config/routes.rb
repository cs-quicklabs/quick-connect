Rails.application.routes.draw do
  require "sidekiq/web"
  require "sidekiq-scheduler/web"

  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"
  devise_for :users, controllers: { registrations: "registrations" }
  post "/register", to: "registrations#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
  resources :user
    resources :profile do
      resources :notes, module: "profile"
    end
  resources :timeline
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :contacts
  get "search/contacts", to: "search#contacts"
  root :to => "dashboard#index"
  resources :dashboard 
  resources :sections

  scope "/settings" do
    get "/profile", to: "user#profile", as: "user_profile"
    get "/password", to: "user#password", as: "setting_password"
    patch "/password", to: "user#update_password", as: "change_password"
    get "/preferences", to: "user#preferences", as: "user_preferences"
  end
  put ":id/permission", to: "user#update_permission", as: "set_permission"

  namespace :account do
    resources :relatives, except: [:new, :show]
    resources :labels, except: [:new, :show]
  end
  namespace :purchase do
    resources :checkouts
  end
  get "account/billing", to: "account/billing#index", as: "billing"
end
