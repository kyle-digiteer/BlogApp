Rails.application.routes.draw do
  resources :posts do
    member do
      post :edit
    end
  end
  get 'feed', to: 'posts#feed'
  root 'posts#feed'

  devise_for :users
  # allows all devise links ( sign up links, edit links)
end
