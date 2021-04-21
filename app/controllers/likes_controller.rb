class LikesController < ApplicationController

  before_action :set_playlist

  def create
    respond_to do |format|
      @playlist.likers << current_user
      format.turbo_stream
    end
  end
  
  def destroy
    respond_to do |format|
      @like = current_user.likes.find_by(playlist_id: params[:playlist_id])
      @like.destroy
      set_playlist
      format.turbo_stream
    end
  end


  private

    def set_playlist
      @playlist = Playlist.find(params[:playlist_id])
    end
end
