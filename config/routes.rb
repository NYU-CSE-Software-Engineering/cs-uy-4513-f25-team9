Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :listings do
    resources :reports, only: [:new, :create]
    resources :conversations, only: [:new, :create]
  end

  get '/liked_listings', to: 'listings#liked', as: :liked_listings

  get '/seller_home', to: 'listings#seller_home', as: :seller_home

  resources :conversations, only: [:index, :show] do
    resources :messages, only: [:create]
  end

  get '/feed', to: 'feed#index'
  post '/swipes', to: 'swipes#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy' 
  
  resources :users, only: [:index, :destroy, :new, :create]
  

  # Show login page as root for unauthenticated users, feed#index for logged-in users
  authenticated = lambda { |req| req.session[:user_id].present? }
  constraints authenticated do
    root to: "feed#index", as: :authenticated_root
  end
  root to: "sessions#new"


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Purchase history
  get '/purchases', to: 'purchases#index'

  # Moderations
  get '/moderations/user_list', to: 'moderations#user_list', as: :moderations
  get '/moderations/reported_listings', to: 'moderations#reported_listings', as: :reported_listings
  delete '/moderations/listings/:id', to: 'moderations#destroy_listing', as: :moderations_listing
  delete '/moderations/users/:id', to: 'moderations#destroy_user', as: :moderations_user
  patch '/moderations/users/:id/remove_moderator', to: 'moderations#remove_moderator', as: :remove_moderator
end