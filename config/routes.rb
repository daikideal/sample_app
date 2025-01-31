Rails.application.routes.draw do

  root 'static_pages#home'
  
  get '/help', to:'static_pages#help'

  get '/about', to:'static_pages#about'
  
  get '/contact', to:'static_pages#contact'
  
  get '/signup', to:'users#new'
  
  get '/login', to:'sessions#new'
  
  post '/login', to:'sessions#create'
  
  delete '/logout', to:'sessions#destroy'
  
  post '/signup', to:'users#create'
  
  # Usersコントローラにfollowingアクションとfollowersアクションを追火
  resources :users do
    # ユーザーidが含まれているURLを扱うようにする
    member do
      get :following, :followers
    end
  end
  
  resources :account_activations, only: [:edit]
  
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :microposts, only: [:create, :destroy]
  
  resources :relationships, only: [:create, :destroy]
  
end
