class CreateSongs < ActiveRecord::Migration[6.0]
  def change
    create_table :songs do |t|
      t.datetime :release_date
      t.string :artist
      t.string :album
      t.string :uri
      t.string :spotify_id
      t.belongs_to :spotify_source_playlist, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
