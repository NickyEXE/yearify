Rails.application.routes.draw do
  resources :destination_playlists, only: [:create]
  resources :sessions, only: [:new]
  resources :users, only: [:show]
  get '/test_source_playlists', to: 'tests#source_playlists', as: "test_source_playlists"
  delete '/destination_playlists', to: 'destination_playlists#destroy_all'
  delete '/sessions', to: 'sessions#logout'
  get '/auth', to: "sessions#create"
  root 'sessions#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
