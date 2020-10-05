class CreateDestinationPlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :destination_playlists do |t|
      t.string :spotify_id
      t.string :name
      t.string :description
      t.string :href
      t.string :uri
      t.belongs_to :user, null: false, foreign_key: true
      t.string :year
      t.boolean :populated, default: false

      t.timestamps
    end
  end
end
