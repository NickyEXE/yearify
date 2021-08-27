class AddLockVersionToSourcePlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :spotify_source_playlists, :lock_version, :integer
  end
end
