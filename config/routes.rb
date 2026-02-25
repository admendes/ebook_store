Rails.application.routes.draw do
  root "users#index"
  
  resources :users do
    member do
      patch :toggle_status
    end
  end

  resources :ebooks
end