Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/rails-admin', as: 'rails_admin'

  authenticate :user, ->(u) { u.admin? } do
    mount MissionControl::Jobs::Engine, at: "/jobs"
  end

  get 'collections/create'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"
  get "dashboard", to: "dashboards#dashboard"
  get "unsubscribe", to: "dashboards#unsubscribe"
  get "subscribe", to: "dashboards#subscribe"
  post "cart_order", to: "carts#cart_order"
  post "single_tracks_cart", to: "carts#single_tracks"
  get "cart", to: "carts#cart"
  post "remove_item", to: "carts#delete_item"
  get "remove_track", to: "carts#delete_track"
  post "single_tracks_cart_remove", to: "carts#single_tracks_cart_remove"
  post "checkout", to: "orders#checkout"
  get "destroy_order", to: "orders#destroy"
  get "update_order_status", to: "orders#update_order_status"
  get "destroy_order_dashboard", to: "orders#destroy_from_dashboard"
  get "destroy_cart", to: "carts#destroy_cart"
  get "about", to: "pages#about"
  get "eula", to: "pages#eula"
  get "blog", to: "pages#blog"
  get "the_quest", to: "pages#the_quest"
  post "subscribe_no_user", to: "pages#subscribe"
  resources :sfx_packs, only: :show
  resources :orders, only: [:show, :create] do
    resources :payments, only: :new
  end
  resources :sales, only: [:new, :create, :destroy]

  get 'list', to: 'single_tracks#index'
  get 'download_single', to: 'single_tracks#download_single'
  get 'create_zip', to: 'single_tracks#create_zip'
  get 'create_zip_collection', to: 'collections#create_zip_collection'

  resources :collections, only: [:create, :update, :show]
  post "name_update", to: "collections#name_update"
  post "convert", to: "collections#convert"
  post "remove_collection_from_cart", to: "collections#remove_collection_from_cart"
  delete "destroy_collection", to: "collections#destroy_collection"

  # create collection template --> admin
  post "create_collection_template", to: "collections#create_template"
  get "collection_templates", to: "collections#templates_index"
  get "collection_templates/:id", to: "collections#templates_show", as: :collection_template

  # user add template to cart and convert into collection
  get "add_template_to_cart", to: "collections#add_template_to_cart"

  # Sound Designer Submission
  resources :designer_submissions, only: %i(new create show update) do
    resources :submission_links, only: :create
  end

  resources :submission_links, only: :destroy

  # thank you for your submission
  get "thank_you", to: "designer_submissions#thank_you", as: :thank_you

  # admin routes
  get "admin", to: "administrator#admin"
  get "admin/designer_submissions", to: "administrator#designer_submissions", as: :submissions
  get "submission_accepted/:id", to: "administrator#submission_accepted", as: :submission_accepted
  get "submission_rejected/:id", to: "administrator#submission_rejected", as: :submission_rejected

  # data protection path
  get "data_protection", to: "pages#data_protection"

  # modal close path
  get "modal_closed", to: "pages#modal_closed"

  # jobs routes
  delete "jobs/:job_id", to: "jobs#destroy", as: :job

  # mount StripeEvent::Engine, at: '/stripe-webhooks'
end
