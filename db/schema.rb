# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_15_215411) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "destination_playlists", force: :cascade do |t|
    t.string "spotify_id"
    t.string "name"
    t.string "description"
    t.string "href"
    t.string "uri"
    t.bigint "user_id", null: false
    t.string "year"
    t.boolean "populated", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_destination_playlists_on_user_id"
  end

  create_table "songs", force: :cascade do |t|
    t.datetime "release_date"
    t.string "artist"
    t.string "album"
    t.string "uri"
    t.string "spotify_id"
    t.bigint "spotify_source_playlist_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "album_type"
    t.index ["spotify_source_playlist_id"], name: "index_songs_on_spotify_source_playlist_id"
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "spotify_source_playlists", force: :cascade do |t|
    t.string "name"
    t.string "uri"
    t.string "spotify_id"
    t.string "description"
    t.string "tracks_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_spotify_source_playlists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "display_name"
    t.string "uri"
    t.string "spotify_id"
    t.string "refresh_token"
  end

  add_foreign_key "destination_playlists", "users"
  add_foreign_key "songs", "spotify_source_playlists"
  add_foreign_key "songs", "users"
  add_foreign_key "spotify_source_playlists", "users"
end
