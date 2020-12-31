Rails.application.routes.draw do
  root "playlists#index"
  resources :users
  resources :playlists
  resource :session, only: :create

  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"
  
  get "/auth/spotify/callback", to: "playlists#spotify"

  post "follow/:playlist_id", to: "follows#create", as: "follow"
  delete "follow/:playlist_id", to: "follows#destroy", as: "unfollow"
end
