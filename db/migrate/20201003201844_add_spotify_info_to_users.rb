class AddSpotifyInfoToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :display_name, :string
    add_column :users, :uri, :string
  end
end
