Myflix::Application.routes.draw do
  
  root to: "static_pages#home"
  resources :users
  get 'people', to: "relationships#index"

  resources :sessions, only: [:new, :create, :destroyy]
  get 'logout'  => 'sessions#destroy'

  resources :relationships, only: [:create, :destroy]

  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  resources :videos, only: :show do
    collection do
      get :search, to: 'videos#search'
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: :show 

  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'  

  get 'forgot_password', to: 'forgot_passwords#new'
  resources 'forgot_passwords', only: [:create]
  get 'forgot_password_confirmation', to: "forgot_passwords#confirm"
  resources :password_resets, only: [:show, :create]
  get 'expired_token', to: 'password_resets#expired_token'

  resources :invitations, only: [:new, :create]
end