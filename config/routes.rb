Rails.application.routes.draw do
  devise_for :users

  resources :favorites
  resources :users
  resources :notes

  # get 'teases/create_teases', to: 'teases#create_teases'
  # get 'teases/view_teases', to: 'teases#view_teases'

  resources :teases

  resources :topics do
    resources :notes
  end

  resources :notes do
    collection do
      post :preview
    end
  end

  # resources :teases do
  #   collection do
  #     get :create_teases
  #   end
  # end

  # resources :topics
  
  # resources :teases do
  #   collection do
  #     get :view_teases
  #   end
  # end
  
  get 'friends', to: 'users#friends' 
  

  get 'tools', to: 'pages#tools'

  get "/navigate" => "pages#navigate", as: :navigate
  
  # root "pages#navigate"
  #use this if you want to see the landing page, but the plotting feature will not work.
  root "home#index"

  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get "/your_first_screen" => "pages#first"
end
