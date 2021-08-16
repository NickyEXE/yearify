class SpotifySourcePlaylist < ApplicationRecord
  belongs_to :user
  has_many :songs


  def get_self
    SpotifyApi.get(user, "/playlists/#{spotify_id}")
  end

  def get_tracks
    SpotifyApi.get(user, "/playlists/#{spotify_id}/tracks")
  end

  def get_songs_without_token
    get_songs(user.get_new_token)
  end


  # Token-Dependent

  def get_songs(token)
    total_songs = fetch_songs(token, 0)
    i = 100
    while i < total_songs do
      fetch_songs(token, i)
      i = i + 100
    end
  end

  def fetch_songs(token, offset)
    res = SpotifyApi.get_with_token(token, "/playlists/#{spotify_id}/tracks?offset=#{offset}`")
    if res
      save_songs(res)
      return res["total"]
    else
      return 0
    end
  end

  def save_songs(res)
    res["items"] && res["items"].each do |item|
      track = item["track"]
      unless !track
        song = Song.find_or_create_by(spotify_id: track["id"], user: user) do |s|
          if track["album"]["release_date"]
            date_array = track["album"]["release_date"].split("-")
            s.release_date = DateTime.new(date_array[0].to_i)
          end
          s.artist = track["artists"][0]["name"]
          s.album = track["album"]["name"]
          s.album_type = track["album"]["album_type"]
          s.uri = track["uri"]
          s.user = user
          s.spotify_source_playlist = self
        end
      end
    end
  end

  def self.grab_all_playlists(user)
    token = user.get_new_token
    first_playlists = get_by_token_and_offset(token, 0)
    create_playlists(first_playlists, user)
    total_playlists = first_playlists["total"]
    i = 20
    while i < total_playlists do
      playlists = get_by_token_and_offset(token, i)
      create_playlists(playlists, user)
      i = i + 20
    end
  end

  def self.get_by_token_and_offset(token, offset)
    SpotifyApi.get_with_token(token, "/me/playlists?offset=#{offset}")
  end

  def self.create_playlists(playlists, user)
    return playlists["items"].map{|p| create_from_spotify(p, user)}
  end

  def self.create_from_spotify(spotify_playlist, user)
    find_or_create_by(spotify_id: spotify_playlist["id"]) do |p|
      p.name = spotify_playlist["name"]
      p.uri = spotify_playlist["uri"]
      p.description = spotify_playlist["description"]
      p.tracks_url = spotify_playlist["tracks"]["href"]
      p.user = user
    end
  end


end
