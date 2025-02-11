# config/routes.rb
Rails.application.routes.draw do
  devise_for :users
  resources :transactions, only: [:index]
  
  root "transactions#index"

  # Keep your existing health check routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end