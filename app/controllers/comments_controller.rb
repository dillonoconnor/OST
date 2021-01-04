class CommentsController < ApplicationController
  def new
  end

  def create
    @playlist = Playlist.find(params[:playlist_id])
    @comment = @playlist.comments.new(message: params[:comment][:message], user_id: current_user.id)
    if @comment.save
      redirect_to @playlist
    else
      redirect_to @playlist, alert: "Invalid comment."
    end
  end

  def edit
    
  end

  def update
    
  end

  def destroy
    @comment = Comment.find(params[:id])
    @playlist = Playlist.find(params[:playlist_id])
    if current_user && @comment.user_id == current_user.id
      @comment.destroy
      redirect_to @playlist
    end 
  end

    private

      def comment_params
        params.require(:comment).permit(:message, :playlist_id, :user_id)
      end
end
