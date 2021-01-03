class PlaylistsController < ApplicationController

  before_action :require_sign_in, except: [:index, :show, :spotify, :follow_playlist]
  before_action :authorize, only: [:create]
  before_action :find_playlist, only: [:create]
  
  def index
    case params[:filter]
    when "popular"
      @playlist = Playlist.popular
    else
      @playlist = Playlist.chronological
    end
    if current_user
      @follows = current_user.follows.map { |f| f.playlist_id }
      @likes = current_user.likes.map { |l| l.playlist_id }
    end
  end
  
  def show
    @playlist = Playlist.find(params[:id])
    @tracks = Track.where("playlist_id = ?", @playlist.id)
    if current_user
      @like = current_user.likes.find_by(playlist_id: @playlist.id)
    end
  end

  def new
    if params[:playlist_name]
      @playlists = search_playlists(params[:playlist_name])
    end
    @playlist = Playlist.new
  end

  def create
    playlist = Playlist.new
    playlist.name = find_playlist_name(@playlist_id).split("OST")[0].strip
    playlist.image_url = find_picture(@playlist_id)
    if params[:playlist_id]
      playlist.spotify_id = params[:playlist_id]
    else
      playlist.spotify_id = params[:playlist][:id].split("spotify:playlist:")[1]
    end
    tracks = find_tracks(@playlist_id)
    tracks.each do |track|
      playlist.tracks.new(title: track.name, 
                          artist: track.artists.first.name)
    end
    if playlist.save
      redirect_to root_url, notice: "Successfully added playlist!"
    else
      render :new, alert: "There's a problem with the ID."
    end
  end

  def destroy
    @playlist = Playlist.find(params[:id])
    @playlist.destroy
    redirect_to root_url, notice: "Playlist deleted."
  end

  def spotify
    session[:spotify_user] = RSpotify::User.new(request.env['omniauth.auth'])
    redirect_to root_url
  end

  private

    def authorize
      RSpotify.authenticate(ENV["spotify_key"], ENV["spotify_secret"])
    end

    def playlist_params
      params.require(:playlist).permit(:id)
    end

    def find_playlist
      if params[:playlist]
        id = params[:playlist][:id].split("spotify:playlist:")[1]
      elsif params[:playlist_id]
        id = params[:playlist_id]
      end
      @playlist_id = RSpotify::Playlist.find_by_id(id)
    end

    def find_playlist_name(playlist)
      playlist.name
    end

    def find_tracks(playlist)
      playlist.tracks.each { |track| }
    end

    def find_picture(playlist)
      playlist.images.first['url']
    end

    def search_playlists(playlist)
      RSpotify::Playlist.search(playlist)
    end

end
