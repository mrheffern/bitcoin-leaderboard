Rails.application.routes.draw do
  # Remove these individual routes since we're using 'resources'
  # get "transactions/index"
  # get "transactions/show"

  devise_for :users
  resources :transactions, only: [:index, :show, :new, :create]

  # Change the root route to point to our transactions index
  root "transactions#index"

  # Keep these useful default routes
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end