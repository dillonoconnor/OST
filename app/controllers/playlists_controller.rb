class PlaylistsController < ApplicationController

  before_action :require_sign_in, except: [:index, :show, :spotify, :follow_playlist]
  before_action :authorize, only: [:create]
  
  def index
    case params[:filter]
    when "popular"
      @playlist = Playlist.popular.paginate(page: params[:page], per_page: 12)
    else
      @playlist = Playlist.chronological.paginate(page: params[:page], per_page: 12)
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
      @playlists = Playlist.search_playlists(params[:playlist_name])
    end
    @playlist = Playlist.new
  end

  def create
    playlist = Playlist.prepare_playlist(params)
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

end
