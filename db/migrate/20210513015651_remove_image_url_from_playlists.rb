class RemoveImageUrlFromPlaylists < ActiveRecord::Migration[6.1]
  def change
    remove_column :playlists, :image_url, :string
  end
end
