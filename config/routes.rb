# frozen_string_literal: true

Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root to: redirect('/projects')

  resources :projects do
    namespace :project_admin, as: 'admin' do
      resources :workflows do
        scope module: :workflows do
          resources :statuses, only: %i[index] do
            get :edit, on: :collection
            put '/', action: :batch_update, on: :collection
          end
        end
      end
    end
  end

  resources :tasks do
    patch :change_status, on: :member
  end
end
