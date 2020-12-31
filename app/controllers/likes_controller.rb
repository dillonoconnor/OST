class LikesController < ApplicationController

  before_action :set_playlist

  def create
    @playlist.likers << current_user
    redirect_to root_url
  end
  
  def destroy
    @like = current_user.likes.find_by(params[:playlist_id])
    @like.destroy
    redirect_to root_url
  end


  private

    def set_playlist
      @playlist = Playlist.find(params[:playlist_id])
    end
end
