class FollowsController < ApplicationController

  before_action :require_sign_in
  before_action :set_playlists
  before_action :find_spotify_user

  def create
    @follow = @local_playlist.follows.create!(user_id: current_user.id)
    @followed_playlists = @spotify_user.playlists.map { |p| p.name }
    unless @followed_playlists.include?(@spotify_playlist.name)
      @spotify_user.follow(@spotify_playlist)
    end
    redirect_to root_url, notice: "Followed playlist on Spotify."
  end

  def destroy
    @spotify_user.unfollow(@spotify_playlist)
    current_user.follows.find_by(playlist_id: params[:playlist_id]).destroy
    redirect_to root_url, alert: "Unfollowed playlist on Spotify."
  end

    private

      def set_playlists
        @local_playlist = Playlist.find(params[:playlist_id])
        @spotify_playlist = RSpotify::Playlist.find_by_id(@local_playlist.spotify_id)
      end

      def find_spotify_user
        @spotify_user = RSpotify::User.find(session[:spotify_user]["id"])
      end
end
