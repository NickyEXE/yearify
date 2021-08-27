class AddNeededRequestsToSourcePlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :spotify_source_playlists, :needed_requests, :integer
  end
end
