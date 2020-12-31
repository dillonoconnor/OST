class AddNameToPlaylists < ActiveRecord::Migration[6.1]
  def change
    add_column :playlists, :name, :string
  end
end
