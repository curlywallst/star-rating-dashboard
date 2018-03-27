Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "application#home"

  get '/users/add-user', to: 'users#edit', as: "add_user"
  post '/users/add-user', to: 'users#update'
end
