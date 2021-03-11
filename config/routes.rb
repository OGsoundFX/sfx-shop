Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"
  get "dashboard", to: "dashboards#dashboard"
  get "unsubscribe", to: "dashboards#unsubscribe"
  get "subscribe", to: "dashboards#subscribe"
  post "cart_order", to: "carts#cart_order"
  get "cart", to: "carts#cart"
  post "remove_item", to: "carts#delete_item"
  post "checkout", to: "orders#checkout"
  get "destroy_order", to: "orders#destroy"
  get "destroy_order_dashboard", to: "orders#destroy_from_dashboard"
  get "destroy_cart", to: "carts#destroy_cart"
  get "admin", to: "administrator#admin"
  get "about", to: "pages#about"
  get "eula", to: "pages#eula"
  get "blog", to: "pages#blog"
  post "subscribe_no_user", to: "pages#subscribe"
  resources :sfx_packs, only: :show
  resources :orders, only: [:show, :create] do
    resources :payments, only: :new
  end
  resources :sales, only: [:new, :create, :destroy]

  mount StripeEvent::Engine, at: '/stripe-webhooks'
end
