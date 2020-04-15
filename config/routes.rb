Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  # Sidekiq GUI for job monitoring
    if Rails.env.development?
      require 'sidekiq/web'
      require 'sidekiq-scheduler/web'
      mount Sidekiq::Web => '/sidekiq'
    end

    # devise_for :users
    namespace :api do
      scope :v1 do
        mount_devise_token_auth_for 'User', at: 'auth'
      end
    end

    # namespace :api, defaults: { format: :json } do
    #     namespace :v1 do
    #       # API v1 routes go here
    #       root to: 'home#index', via: :all
    #     end
    # end

    root to: 'home#index', via: :all
end
