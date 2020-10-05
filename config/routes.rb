Rails.application.routes.draw do
  resources :destination_playlists
  resources :users
  get '/auth', to: "users#auth"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
