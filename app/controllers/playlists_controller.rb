class PlaylistsController < ApplicationController

  before_action :require_sign_in, except: [:index, :show, :spotify, :follow_playlist]
  before_action :authorize, only: [:create]
  
  def index
    case params[:filter]
    when "popular"
      @playlist = Playlist.popular.paginate(page: params[:page], per_page: 10)
    else
      @playlist = Playlist.chronological.paginate(page: params[:page], per_page: 10)
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
    @comment = Comment.new
    @comments = Comment.where(playlist_id: params[:id])
  end

  def new
    if params[:playlist_name]
      @playlists = search_playlists(params[:playlist_name])
    end
    @playlist = Playlist.new
  end

  def create
    spotify_playlist = find_spotify_playlist
    playlist = Playlist.new(
      name: find_playlist_name(spotify_playlist),
      image_url: find_picture(spotify_playlist),
      spotify_id: find_spotify_id
    )
    spotify_playlist.tracks.each do |track|
      playlist.tracks.new(
        title: track.name, 
        artist: track.artists.first.name
      )
    end
    if playlist.save
      redirect_to root_url, notice: "Successfully added playlist!"
    else
      render :new, alert: "There's a problem with the ID."
    end
  end

  def destroy
    @playlist = Playlist.find_by(id: params[:id])
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

    def sanitize_playlist_params
      if params[:playlist]
        params[:playlist][:id].split("spotify:playlist:")[1]
      elsif params[:playlist_id]
        params[:playlist_id]
      end
    end

    def find_spotify_playlist
      id = sanitize_playlist_params
      @playlist_id = RSpotify::Playlist.find_by_id(id)
    end

    def find_playlist_name(playlist)
      playlist.name.split("OST")[0].strip
    end

    def find_picture(playlist)
      playlist.images.first['url']
    end

    def find_spotify_id
      if params[:playlist_id]
        params[:playlist_id]
      else
        params[:playlist][:id].split("spotify:playlist:").first
      end
    end

    def search_playlists(playlist)
      RSpotify::Playlist.search(playlist)
    end

end
