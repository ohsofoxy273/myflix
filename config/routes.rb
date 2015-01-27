Myflix::Application.routes.draw do

  mount StripeEvent::Engine => '/stripe'

  root to: "static_pages#home"
  resources :users
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'people', to: "relationships#index"

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

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
  get 'expired_token', to: 'pages#expired_token'

  resources :invitations, only: [:new, :create]
end