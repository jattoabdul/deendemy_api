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
            resources :carts, only: [:index, :show] do
              collection do
                post '/add' => :add_to_cart # /account/:account_id/carts/add
                post '/remove' => :remove_from_cart # /account/:account_id/carts/remove
              end
            end
            resources :wishlists, only: [:index, :show] do
              collection do
                post '/add' => :add_to_wishlist # /account/:account_id/wishlists/add
                post '/remove' => :remove_from_wishlist # /account/:account_id/wishlists/remove
              end
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
            member do
              post '/approve' => :approve
              get '/ratings' => :fetch_course_reviews
              get '/reviews' => :fetch_course_reviews
            end
            collection do
              get '/tutor' => :fetch_tutor_courses
              get '/all' => :fetch_all
            end
            resources :lessons, only: [] do
              resources :lesson_discussions, only: [:index, :create, :update, :show, :destroy], path: '/discussions'
              collection do
                post :introduction
                get '/introduction' => :introduction_index
                put '/introduction' => :update_introduction
              end
            end
            resources :chapters, only: [:index, :create, :update, :show, :destroy] do
              collection do
                post '/positions' => :update_positions
              end
              resources :lessons, only: [:index, :create, :update, :show, :destroy] do
                collection do
                  post '/positions' => :update_positions
                  post  '/assessments' => :create_lesson_assessment
                  put  '/assessments/:assessment_id' => :update_lesson_assessment
                end
              end
            end
            resources :enrollments, only: [] do
              collection do
                get '/' => :fetch_course_enrollments
              end
            end
          end
          resources :chapters, only: [] do
            collection do
              get '/' => :all_chapters
            end
          end
          resources :lessons, only: [:create, :update, :show, :destroy] do
            collection do
              get '/' => :all_lessons
            end
          end
          resources :enrollments, only: [:index, :create, :show, :destroy] do
            member do
              match '/status' => :toggle_enrollment_status, via: [:put, :patch]
              get '/progress' => :fetch_enrollment_lesson_progresses
              post '/progress/reset' => :reset_enrollment_progress
              post '/courses/:course_id/lessons/:lesson_id/start' => :start_enrollment_lesson
              post '/courses/:course_id/lessons/:lesson_id/complete' => :complete_enrollment_lesson
              post '/courses/:course_id/rate' => :rate_course
            end
            collection do
              get '/learners/:learner_id' => :fetch_learner_enrollments
              get '/courses/:course_id' => :fetch_course_enrollments
            end
          end
          resources :payments, only: [:index] do
            member do
              get '/' => :fetch_single_payment
            end
            collection do
              post '/charge' => :charge # /payments/charge
              get '/learners/:learner_id' => :fetch_learner_payments
            end
          end

          root to: 'home#index', via: :all
        end
    end

    # Websocket event listener
    mount ActionCable.server => '/cable/:uid'

    root to: 'home#index', via: :all
end
