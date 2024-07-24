Rails.application.routes.draw do
  resources :favorites
  resources :users
  resources :topics
  resources :notes
  devise_for :users
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:

  # get "/your_first_screen" => "pages#first"
  root "pages#home"
  #get 'pages/home'
end
