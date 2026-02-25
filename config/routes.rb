Rails.application.routes.draw do
  root "ebooks#index"

  resources :users do
    member do
      patch :toggle_status
    end
  end

  resources :ebooks do
    member do
      patch :advance_status
      get :download_preview
    end
  end

  resources :purchases, only: [:create]
end