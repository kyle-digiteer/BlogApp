Rails.application.routes.draw do
  devise_for :users  # allows all devise links ( sign up links, edit links)
  

  resources :posts 
  get "feed", to: "posts#feed"


  root "posts#feed"
end
