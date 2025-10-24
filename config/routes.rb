Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :moderations do
    get 'reported_listings', to: 'moderations#reported_listings'
    post 'confirm_remove', to: 'moderations#confirm_remove'
    get 'delete_confirmation', to: 'moderations#delete_confirmation'
    get 'access_denied', to: 'moderations#access_denied'
  end

  Rails.application.routes.draw do
  # Moderation API routes
  namespace :api do
    namespace :v1 do
      delete 'moderations/listing/:listing_id', to: 'moderations#api_remove_listing'
    end
  end

  # Existing routes...
end

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
