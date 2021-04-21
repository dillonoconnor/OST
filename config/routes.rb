

Rails.application.routes.draw do

  root "playlists#index"
  resources :users, except: [:index]
  resources :playlists do
    resources :comments
  end
  resource :session, only: :create

  get "login", to: "sessions#new"
  delete "logout", to: "sessions#destroy"
  
  get "/auth/spotify/callback", to: "playlists#spotify", as: "spotify"

  post "follow/:playlist_id", to: "follows#create", as: "follow"
  delete "follow/:playlist_id", to: "follows#destroy", as: "unfollow"

  post "like/:playlist_id", to: "likes#create", as: "like"
  delete "like/:playlist_id", to: "likes#destroy", as: "unlike"

  get 'playlists/filter/:filter', to: 'playlists#index', as: 'filtered_playlists'
end
