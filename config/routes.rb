Rails.application.routes.draw do
  devise_for :users

  resources :favorites
  resources :users
  resources :notes

  resources :topics do
    resources :notes
  end

  resources :notes do
    collection do
      post :preview
    end
  end

  get 'tools', to: 'pages#tools'
  get 'teases', to: 'pages#teases'

  root "pages#navigate"
end
