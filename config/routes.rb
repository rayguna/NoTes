Rails.application.routes.draw do
  resources :follow_requests
  devise_for :users

  resources :favorites
  resources :users
  resources :notes

  resources :teases

  resources :topics do
    resources :notes
  end

  resources :notes do
    collection do
      post :preview
    end
  end
  
  get 'friends', to: 'users#friends' 
  

  get 'tools', to: 'pages#tools'

  get "/navigate" => "pages#navigate", as: :navigate
  
  root "home#index"

  resources :follow_requests

  # config/routes.rb
  resources :follow_requests do
    member do
      patch :accept
    end
  end

end
