Rails.application.routes.draw do
  resources :posts
  get "feed", to: "posts#feed"
end
