class AddPlaylistIdToPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :playlist_id, :string
    remove_column :playlists, :title, :string
  end
end
