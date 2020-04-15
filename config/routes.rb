Rails.application.routes.draw do
  # Sidekiq GUI for job monitoring
    if Rails.env.development?
      require 'sidekiq/web'
      require 'sidekiq-scheduler/web'
      mount Sidekiq::Web => '/sidekiq'
    end

    namespace :api, defaults: { format: :json } do
        namespace :v1 do
          # API v1 routes go here
          mount_devise_token_auth_for 'User', as: 'v1', at: 'auth'

          resources :categories, only: [:index, :show, :create, :update, :destroy]

          root to: 'home#index', via: :all
        end
    end

    root to: 'home#index', via: :all
end
