class AddTotalRequestsToSourcePlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :spotify_source_playlists, :total_requests, :integer
  end
end
