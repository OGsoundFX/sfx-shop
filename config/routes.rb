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
  resources :sfx_packs, only: [:show, :index]

  resources :sound_designers, only: [:new, :create, :show] do
    resources :sfx_packs, only: [:create, :update]
  end

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
  resources :designer_submissions, param: :access_token, only: %i(new create show update) do
    resources :submission_links, only: :create
  end

  resources :designer_submissions, only: :destroy
  resources :submission_links, only: :destroy

  # thank you for your submission
  get "thank_you", to: "designer_submissions#thank_you", as: :thank_you

  # admin routes
  get "admin", to: "administrator#admin"
  get "admin/designer_submissions", to: "administrator#designer_submissions", as: :submissions
  get "admin/stats", to: "administrator#stats", as: :stats
  get "admin/sales", to: "administrator#sales", as: :list_sales
  get "admin/payouts", to: "administrator#payouts", as: :payouts
  get "submission_accepted/:id", to: "administrator#submission_accepted", as: :submission_accepted
  get "submission_rejected/:id", to: "administrator#submission_rejected", as: :submission_rejected
  get "calculate_exchange_rate", to: "administrator#calculate_exchange_rate", as: :calculate_exchange_rate
  resources :payouts, only: [:new, :create]

  # sound designer dashboard routes
  get "designer_dashboard", to: "designer_dashboards#main", as: :designer_main_dashboard
  get "your_listings", to: "designer_dashboards#listings", as: :designer_listings
  get "sales", to: "designer_dashboards#sales", as: :designer_sales
  get "payouts", to: "designer_dashboards#payouts", as: :designer_payouts
  get "add_new_pack", to: "designer_dashboards#pack_form", as: :add_new_pack
  get "update_pack/:id", to: "designer_dashboards#update_pack_form", as: :update_pack
  delete "remove_pack/:id", to: "designer_dashboards#remove_pack", as: :remove_pack
  post "sound_designers/:id/paypal_account", to: "designer_dashboards#paypal_account", as: :paypal_account
  post "sound_designers/:id/update_info", to: "designer_dashboards#update_designer_info", as: :update_designer_info
  post "sound_designers/:id/update_bio", to: "designer_dashboards#update_designer_bio", as: :update_designer_bio
  post "sound_designers/:id/update_photo", to: "designer_dashboards#update_designer_photo", as: :update_designer_photo
  post "sound_designers/:id/banner", to: "designer_dashboards#banner", as: :designer_banner

  # data protection path
  get "data_protection", to: "pages#data_protection"

  # modal close path
  get "modal_closed", to: "pages#modal_closed"

  # jobs routes
  delete "jobs/:job_id", to: "jobs#destroy", as: :job

  mount StripeEvent::Engine, at: '/stripe-webhooks'
  # post "/webhooks/stripe", to: "stripe_webhook#receive"
end
