Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

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
  get "/reset" => "user#reset", as: "reset_user"
  get "/destroy" => "user#destroy", as: "destroy_user"
  resources :contacts do
    resources :notes, module: "contact"
    resources :phone_calls, module: "contact"
    resources :tasks, module: "contact"
    resources :relatives, module: "contact"
    resources :about, module: "contact"
    collection do
      get :form
    end
    resources :debts, module: "contact"
    resources :conversations, module: "contact"
    resources :timeline, module: "contact"
  end
  resources :journals
  resources :release_notes
  resources :journal_comments
  post "/status", to: "status#create", as: "statuses"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/search/contacts", to: "search#contacts"
  get "/search/contact", to: "search#contact"
  root :to => "dashboard#index"
  resources :dashboard
  resources :sections
  get "/contacts/profile/:id", to: "contacts#profile", as: "contact_profile"
  scope "/settings" do
    get "/profile", to: "user#profile", as: "user_profile"
    get "/password", to: "user#password", as: "setting_password"
    patch "/password", to: "user#update_password", as: "change_password"
    get "/preferences", to: "user#preferences", as: "user_preferences"
  end
  put ":id/permission", to: "user#update_permission", as: "set_permission"
  get :events, controller: :dashboard
  namespace :account do
    resources :relations, except: [:new, :show]
    resources :labels, except: [:new, :show]
    resources :fields, except: [:show]
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

  # API namespace, for JSON requests at /api/sign_[in|out]
  namespace :api do
    devise_for :users, defaults: { format: :json },
                       class_name: "ApiUser",
                       skip: [:invitations,
                              :unlocks],
                       path: "",
                       path_names: { sign_in: "login",
                                     sign_out: "logout" }
    devise_scope :user do
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
      post "/users", to: "registrations#create", as: :new_user_registration
    end
    resources :user
    get "/reset" => "user#reset", as: "reset_user"
    get "/destroy" => "user#destroy", as: "destroy_user"
    scope "/settings" do
      get "/profile", to: "user#profile", as: "user_profile"
      get "/password", to: "user#password", as: "setting_password"
      patch "/password", to: "user#update_password", as: "change_password"
      get "/preferences", to: "user#preferences", as: "user_preferences"
      patch "/permission", to: "user#update_permission", as: "change_permission"
    end
    get "/search/contacts", to: "search#contacts"
    resources :dashboard
    scope "archive" do
      get "/contacts", to: "contacts#archived", as: "archived_contacts"
      get "/contact/:id", to: "contacts#archive_contact", as: "archive_contact"
      get "/contact/:id/restore", to: "contacts#unarchive_contact", as: "unarchive_contact"
    end
    namespace :account do
      resources :relations, except: [:show]
      resources :labels, except: [:show]
      resources :fields, except: [:show]
    end

    resources :journals
    resources :release_notes
    resources :journal_comments
    resources :ratings, only: [:create, :index]
    resources :contacts do
      resources :notes, module: "contact"
      resources :phone_calls, module: "contact"
      resources :tasks, module: "contact" do
        get "status", to: "tasks#status", as: "status"
      end
      resources :debts, module: "contact"
      resources :conversations, module: "contact"
      resources :profile, module: "contact"
      resources :relatives, module: "contact"
      resources :about, module: "contact"
      resources :labels, module: "contact", only: [:index, :update, :destroy]
      resources :relations, module: "contact", only: [:index, :update, :destroy]
      resources :timeline, module: "contact"
    end
  end
end
