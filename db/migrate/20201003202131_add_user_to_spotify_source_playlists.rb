class AddUserToSpotifySourcePlaylists < ActiveRecord::Migration[6.0]
  def change
    add_reference :spotify_source_playlists, :user, null: false, foreign_key: true
  end
end
