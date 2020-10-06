Rails.application.routes.draw do
  resources :destination_playlists, only: [:create, :destroy]
  resources :sessions, only: [:new, :destroy]
  resources :users, only: [:show]
  get '/auth', to: "sessions#create"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
