Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "pages#home"
  resources :sfx_packs, only: :show
  resources :orders, only: [:show, :create] do
    resources :payments, only: :new
  end
end
