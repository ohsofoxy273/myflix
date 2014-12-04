Myflix::Application.routes.draw do
  
  root to: "static_pages#home"
  resources :users
  resources :sessions, only: [:new, :create, :destroyy]
  get 'logout'  => 'sessions#destroy'

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
end