Rails.application.routes.draw do
  devise_for :users

  resources :users do
    get 'friends', on: :collection
  end

  resources :favorites
  resources :notes do
    collection do
      post :preview
    end
  end

  resources :teases

  resources :topics do
    resources :notes, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  end


  resources :follow_requests do
    member do
      patch :accept
    end
    collection do
      get :approved_requests
    end
  end
  

  get 'tools', to: 'pages#tools'
  get 'navigate', to: 'pages#navigate', as: :navigate
  
  root "home#index"

  resources :topics do
    member do
      post :share
    end
  end

  resources :topics do
    member do
      post :share
    end
  end  
  
  get 'search', to: 'search#index'

  get 'tools', to: 'pages#tools'


end
