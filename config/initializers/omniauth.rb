require 'rspotify/oauth'

Rails.application.config.to_prepare do
  OmniAuth::Strategies::Spotify.include SpotifyOmniauthExtension
end 

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify,
    ENV["spotify_key"],
    ENV["spotify_secret"],
    scope: 'user-read-email playlist-read-private playlist-modify-public playlist-modify-private user-library-read user-library-modify'
end