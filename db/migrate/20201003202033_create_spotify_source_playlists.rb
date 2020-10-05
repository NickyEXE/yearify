class CreateSpotifySourcePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_source_playlists do |t|
      t.string :name
      t.string :uri
      t.string :spotify_id
      t.string :description
      t.string :tracks_url

      t.timestamps
    end
  end
end
