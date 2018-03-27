Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "application#home"

  get '/users/add-user/:username', to: 'users#edit', as: "add_user"
  patch '/users/add-user/:username', to: 'users#update'
  get '/users/search-user', to: 'users#search', as: "find_user"
  post '/users/search-user', to: 'users#find'
end
