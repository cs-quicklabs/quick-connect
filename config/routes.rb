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
      resources :phone_calls, module: "profile"
      resources :tasks, module: "profile"
      resources :relatives, module: "profile"
      collection do
        get :form
      end
      resources :timeline,  module: "profile"
    end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :contacts
  get "search/contacts", to: "search#contacts"
  get "search/contact", to: "search#contact"
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
    resources :relations, except: [:new, :show]
    resources :labels, except: [:new, :show]
  end
  namespace :purchase do
    resources :checkouts
  end
  scope "archive" do
    get "/contacts", to: "contacts#archived", as: "archived_contacts"
    get "/contact/:id", to: "contacts#archive_contact", as: "archive_contact"
    get "/contact/:id/restore", to: "contacts#unarchive_contact", as: "unarchive_contact"
  end
  get "account/billing", to: "account/billing#index", as: "billing"
end
