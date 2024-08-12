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
  end

  get 'tools', to: 'pages#tools'
  get 'navigate', to: 'pages#navigate', as: :navigate
  
  root "home#index"
end
