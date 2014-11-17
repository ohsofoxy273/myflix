Myflix::Application.routes.draw do
  
  resources :users
  resources :sessions, only: [:new, :create, :destroyy]
  get 'logout'  => 'sessions#destroy'

  root to: "static_pages#home"
  get 'ui(/:action)', controller: 'ui'
  get '/home', to: 'videos#index'
  resources :videos, only: :show do
  	collection do
  		get :search, to: 'videos#search'
  	end
  end
  resources :categories, only: :show 
end