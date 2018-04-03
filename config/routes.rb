Rails.application.routes.draw do

  # devise_for :users
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "application#home"

  get '/users/add-user/:username', to: 'users#edit', as: "add_user"
  patch '/users/add-user/:username', to: 'users#update'
  get '/users/search-user', to: 'users#search', as: "find_user"
  post '/users/search-user', to: 'users#find'
  get '/users/add-technical-coach/:username', to: 'users#add_technical_coach', as: "add_technical_coach"
  post '/users/add-technical-coach/:username', to: 'users#set_technical_coach'
  # get '/tc/add-user/:username', to: 'users#edit', as: "add_user"

  get '/tcs', to: 'technical_coaches#index', as: "tcs"
  get '/tcs/:slug', to: 'technical_coaches#show', as: "find_tc"
end
