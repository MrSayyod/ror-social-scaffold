Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:index, :show] do
    get 'make_friend', to: 'users#make_friend', as: 'make_friend'
    get 'send_friend_request', to: 'users#send_friend_request', as: 'send_request'
    get 'ignore_friend_request', to: 'users#ignore_friend_request', as: 'ignore_request'
  end
  resources :posts, only: [:index, :create] do
    resources :comments, only: [:create]
    resources :likes, only: [:create, :destroy]
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end