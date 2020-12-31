class RemovePlaylistIdFromPlaylists < ActiveRecord::Migration[6.1]
  def change
    remove_column :playlists, :playlist_id, :string
  end
end
