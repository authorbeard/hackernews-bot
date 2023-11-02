require 'sidekiq/web'

Rails.application.routes.draw do
  root "stories#index"

  resources :stories, only: [:index] do
    resources :comments, only: [:index]
  end

  mount Sidekiq::Web => "/sidekiq"
end
