Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  require "sidekiq/web"
  require "sidekiq-scheduler/web"

  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => "/cable"

  devise_for :users, controllers: { registrations: "registrations", sessions: "sessions" }
  post "/register", to: "registrations#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  # root "articles#index"
  resources :user
  get "/reset" => "user#reset", as: "reset_user"
  get "/destroy" => "user#destroy", as: "destroy_user"
  match "/contacts.csv" => "export#index", via: :get, defaults: { format: :csv }
  get "/report", to: "reports#index", as: "reports"
  scope "report" do
    get "/events", to: "report/events#index", as: "events_reports"
    get "/contacts", to: "report/contacts#index", as: "contacts_addition_report"
    get "/activities", to: "report/activities#index", as: "activities_report"
    scope "contacts" do
      get "/yearly", to: "report/contacts#yearly", as: "contacts_addition_report_yearly"
      get "/monthly", to: "report/contacts#monthly", as: "contacts_addition_report_monthly"
      get "/weekly", to: "report/contacts#weekly", as: "contacts_addition_report_weekly"
      get "/all", to: "report/contacts#all", as: "contacts_addition_report_all"
    end
    get "/activities", to: "report/activities#index", as: "activities_reports"
    get "/ratings", to: "report/ratings#index", as: "ratings_reports"
  end
  resources :contacts do
    resources :notes, module: "contact", except: [:show]
    resources :phone_calls, module: "contact", except: [:show]
    resources :reminders, module: "contact", except: [:show]
    resources :tasks, module: "contact"
    resources :relatives, module: "contact", except: [:show]
    resources :contact_activities, module: "contact", except: [:show]
    resources :contact_events, module: "contact", except: [:show]
    resources :about, module: "contact", except: [:show]
    resources :documents, module: "contact", except: [:show]
    resources :links, module: "contact", except: [:show, :new, :index], as: "social"
    collection do
      get :form
      post :import
    end
    resources :gifts, module: "contact", except: [:show]
    resources :batches, module: "contact", path: "groups", except: [:show, :new, :update]
    resources :debts, module: "contact", except: [:show]
    resources :conversations, module: "contact", except: [:show]
    resources :timeline, module: "contact", only: [:index]
  end
  get "favorites", to: "favorites#index", as: "favorites"
  resources :journals
  resources :journal_comments
  get "contacts/groups", to: "contacts#groups"
  post "/status", to: "status#create", as: "statuses"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get "/search/contacts", to: "search#contacts"
  get "/search/contact", to: "search#contact"
  get "/search/add", to: "search#add"
  get "/search/nav", to: "search#nav"
  root :to => "dashboard#index"
  get "/dashboard", to: "dashboard#index", as: "dashboard"
  get "followups", to: "followups#index"
  get "/contacts/profile/:id", to: "contacts#profile", as: "contact_profile"
  get "/batches/view/:id", to: "batches#view", as: "batch_view"
  get "/batches/profile", to: "batches#profile", as: "batch_profile"
  scope "/settings" do
    get "/profile", to: "user#profile", as: "user_profile"
    get "/password", to: "user#password", as: "setting_password"
    patch "/password", to: "user#update_password", as: "change_password"
    get "/preferences", to: "user#preferences", as: "user_preferences"
  end
  put ":id/permission", to: "user#update_permission", as: "batch_permission"

  #dashboard
  get :events, controller: :dashboard
  get :tasks, controller: :dashboard
  get :contacted, controller: :dashboard
  get :reminders, controller: :dashboard

  get :ratings, controller: :journals
  resources :batches, except: [:new], path: "groups" do
    get "contacts", to: "batches#contacts", as: "contacts"
    get "/add/:id", to: "batches#add", as: "addcontact"
    delete "/remove/:id", to: "batches#remove", as: "removecontact"
  end
  namespace :account do
    resources :relations, except: [:new, :show]
    resources :labels, except: [:new, :show]
    resources :fields, except: [:show, :new]
    resources :activities, except: [:show, :new]
    resources :life_events, except: [:show, :new]
    match "/contact-sample.csv" => "import#export", via: :get, defaults: { format: :csv }
    get "/export", to: "export#index", as: "export_contacts"
    get "/import", to: "import#index", as: "import_contacts"
    resources :invitations, except: [:show, :new] do
      get "/deactivate", to: "invitations#deactivate", as: "deactivate"
      get "/activate", to: "invitations#activate", as: "activate"
    end
  end
  namespace :purchase do
    resources :checkouts
  end
  scope "archive" do
    get "/contacts", to: "contacts#archived", as: "archived_contacts"
    get "/contact/:id", to: "contacts#archive_contact", as: "archive_contact"
    get "/contact/:id/restore", to: "contacts#unarchive_contact", as: "unarchive_contact"
  end
  scope "untracked" do
    get "/contacts", to: "contacts#untracked", as: "untracked_contacts"

    get "/contact/:id/track", to: "contacts#track", as: "track_contact"
    get "/contact/untrack/:id", to: "contacts#untrack", as: "untrack_contact"
    get "/contact/touch_back/:id", to: "contacts#touch_back", as: "touch_back_contact"
  end
  get "/contact/:id", to: "contacts#touched", as: "touched_contact"
  get "/contact/:id/update_touched", to: "contacts#update_touched", as: "update_touched_contact"
  get "account/billing", to: "account/billing#index", as: "billing"

  # API namespace, for JSON requests at /api/sign_[in|out]
  namespace :api do
    devise_for :users, defaults: { format: :json },
                       class_name: "ApiUser",
                       skip: [:unlocks],
                       path: "",
                       path_names: { sign_in: "login",
                                     sign_out: "logout" }
    devise_scope :user do
      get "login", to: "devise/sessions#new"
      delete "logout", to: "devise/sessions#destroy"
      post "/users", to: "registrations#create", as: :new_user_registration
      post "/invitations", to: "invitations#update", as: :accept_invitation
    end
    get "followups", to: "followups#index"
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
    get "/search/relative", to: "search#relative"
    get "/search/add", to: "search#add"
    get "/dashboard", to: "dashboard#index", as: "dashboard"
    get :recents, controller: :dashboard
    get :favorites, controller: :dashboard
    get :upcomings, controller: :dashboard
    scope "archive" do
      get "/contacts", to: "contacts#archived", as: "archived_contacts"
      get "/contact/:id", to: "contacts#archive_contact", as: "archive_contact"
      get "/contact/:id/restore", to: "contacts#unarchive_contact", as: "unarchive_contact"
    end
    scope "untracked" do
      get "/contacts", to: "contacts#untracked_contact", as: "untracked_contacts"
      get "/contact/:id/track", to: "contacts#track", as: "track_contact"
      get "/contact/:id", to: "contacts#untrack", as: "untrack_contact"
    end

    namespace :account do
      resources :relations, except: [:show, :new]
      resources :labels, except: [:show, :new]
      resources :fields, except: [:show, :new]
      resources :activities, except: [:show]
      resources :life_events, except: [:show]
      resources :invitations, except: [:show, :new] do
        get "/deactivate", to: "invitations#deactivate", as: "deactivate"
        get "/activate", to: "invitations#activate", as: "activate"
      end
    end

    resources :batches, except: [:new] do
      get "contacts", to: "batches#contacts", as: "contacts"
      post "add", to: "batches#add", as: "addcontact"
      post "remove", to: "batches#remove", as: "removecontact"
    end
    resources :journals
    resources :journal_comments
    resources :ratings, only: [:create, :index]
    resources :contacts do
      resources :notes, module: "contact", except: [:show]
      resources :phone_calls, module: "contact", except: [:show]
      resources :reminders, module: "contact", except: [:show]
      resources :tasks, module: "contact" do
        get "status", to: "tasks#status", as: "status"
      end
      resources :gifts, module: "contact", except: [:show]
      resources :debts, module: "contact", except: [:show]
      resources :conversations, module: "contact", except: [:show]
      resources :contact_activities, module: "contact", except: [:show]
      resources :contact_events, module: "contact", except: [:show]
      resources :profile, module: "contact", only: [:index]
      resources :documents, module: "contact", except: [:show]
      resources :batches, module: "contact", except: [:show, :update]
      get "/favorite", to: "contact/profile#favorite"
      resources :relatives, module: "contact", except: [:show]
      resources :abouts, module: "contact", except: [:show]
      resources :timeline, module: "contact", only: [:index]
    end
  end

  namespace :purchase do
    resources :checkouts
  end

  # purchase routes
  get "success", to: "purchase/checkouts#success", as: "success"
  get "expired", to: "purchase/billings#expired", as: "expired"
  post "billings", to: "purchase/billings#create", as: "billing_portal"

  resources :collections

  delete "/collection/:id/group/:batch_id", to: "collections#remove_group", as: "delete_collection_group"
end
