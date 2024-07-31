Rails.application.routes.draw do
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

  get 'tools', to: 'pages#tools'
  get 'teases', to: 'pages#teases'

  root "pages#navigate"

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get "/your_first_screen" => "pages#first"
end
