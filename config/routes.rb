Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Sidekiq GUI for job monitoring
    if Rails.env.development?
      require 'sidekiq/web'
      require 'sidekiq-scheduler/web'
      mount Sidekiq::Web => '/sidekiq'
    end

    # post '/v1/authenticate', to: 'application#authentication_check'

    # root to: 'home#index', via: :all
end
