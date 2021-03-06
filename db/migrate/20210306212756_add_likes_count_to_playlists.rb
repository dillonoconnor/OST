class AddLikesCountToPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :likes_count, :integer
  end
end
