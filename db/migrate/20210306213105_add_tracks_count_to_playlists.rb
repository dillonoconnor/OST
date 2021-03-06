class AddTracksCountToPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :tracks_count, :integer
  end
end
