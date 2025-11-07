Rails.application.routes.draw do
  # Health check (Rails default)
  get "up" => "rails/health#show", as: :rails_health_check

  # Root page
  root "listings#index"

  # Defines the root path route ("/")
  # root "posts#index"

  # Purchase history
  get '/purchases', to: 'purchases#index'
  
  # Listings and nested reports
  resources :listings do
    resources :reports, only: [:new, :create]
  end

  # Authentication routes (for the login redirect)
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
