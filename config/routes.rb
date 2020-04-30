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
          mount_devise_token_auth_for 'User', as: 'v1', at: 'auth', skip: [:invitations]
          devise_for :users, path: 'auth', only: [:invitations], controllers: { invitations: 'api/v1/invitations' }

          resources :accounts, only: [:index] do
            member do
              post '/roles/assign' => :assign_roles # accounts/{user_id}/roles/assign
              post '/roles/unassign' => :unassign_roles # accounts/{user_id}/roles/unassign
            end
            resources :medias, only: [] do
              collection do
                get '/' => :my_media
              end
            end
          end
          resources :events, only: [:index, :show]
          resources :categories, only: [:index, :show, :create, :update, :destroy]
          resources :conversations, only: [:index, :create], shallow: true do
            resources :messages, only: [:index, :create]
          end
          post '/conversations/messages' => 'messages#bulk_create' # /conversations/messages
          resources :notifications, only: [:index, :show] do
            member do
              match '/read' => :mark_as_read, via: [:post, :put, :patch] # /notifications/:id/read
            end
            collection do
              post '/read' => :mark_all_as_read # /notifications/read
              post '/read/all' => :mark_all_as_read
            end
          end
          resources :medias, only: [:index, :create, :update, :show, :destroy]
          resources :courses, only: [:index, :create, :update, :show, :destroy] do
            resources :chapters, only: [:index, :create, :update, :show, :destroy] do
              collection do
                post '/positions' => :update_positions
              end
              resources :lessons, only: [:index, :create, :update, :show, :destroy] do
                collection do
                  post '/positions' => :update_positions
                end
              end
            end
          end
          resources :lessons, only: [:create, :update, :show, :destroy]

          root to: 'home#index', via: :all
        end
    end

    # Websocket event listener
    mount ActionCable.server => '/cable/:uid'

    root to: 'home#index', via: :all
end
