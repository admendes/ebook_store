Rails.application.routes.draw do
  get "tags/index"
  get "tags/new"
  get "tags/edit"
  root "ebooks#index"

  # Authentication
  get    "/login",    to: "sessions#new",     as: :login
  post   "/login",    to: "sessions#create"
  delete "/logout",   to: "sessions#destroy",  as: :logout
  get    "/signup",   to: "registrations#new", as: :signup
  post   "/signup",   to: "registrations#create"

  # Users
  resources :users do
    member do
      patch :toggle_status
    end
  end

  # Ebooks
  resources :ebooks do
    member do
      patch :advance_status
      get   :download_preview
    end
    collection do
      get :filter
    end
  end

  # Tags
  resources :tags

  # Purchases
  resources :purchases, only: [:create]
end