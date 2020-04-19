Rails.application.routes.draw do
  # Sidekiq GUI for job monitoring
    if Rails.env.development?
      require 'sidekiq/web'
      require 'sidekiq-scheduler/web'
      mount Sidekiq::Web => '/sidekiq'
    end

    match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]

    namespace :api, defaults: { format: :json } do
        namespace :v1 do
          # API v1 routes go here
          mount_devise_token_auth_for 'User', as: 'v1', at: 'auth'

          resources :events, only: [:index, :show]
          resources :categories, only: [:index, :show, :create, :update, :destroy]
          resources :conversations, only: [:index, :create], shallow: true do
            resources :messages, only: [:index, :create]
          end

          root to: 'home#index', via: :all
        end
    end

    # Websocket event listener
    mount ActionCable.server => '/cable/:uid'

    root to: 'home#index', via: :all
end
