class AddAlbumTypeToSong < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :album_type, :string
  end
end
