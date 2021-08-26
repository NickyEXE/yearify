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
    # total_songs = fetch_songs(token, 0)
    # i = 100
    # while i < total_songs do
    #   fetch_songs(token, i)
    #   i = i + 100
    # end
    SourcePlaylist::SongsWorker.perform_async(self.id, token, 0)
  end

  def fetch_songs(token, offset)
    res = SpotifyApi.get_with_token(token, "/playlists/#{spotify_id}/tracks?offset=#{offset}")
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
    # Make one non-asynchronous requests to get the whole count of playlists and first 20 playlists,
    # then generate asynchronous requests for each subsequent set of 20 playlists.
    token = user.get_new_token
    first_playlists = get_by_token_and_offset(token, 0)
    create_playlists(first_playlists, user)
    total_playlists = first_playlists["total"]
    offset = 20
    while offset < total_playlists do
      # playlists = get_by_token_and_offset(token, i)
      # create_playlists(playlists, user)
      SourcePlaylist::ImportWorker.perform_async(token, offset, user.id)
      offset = offset + 20
    end
    Song::InitializeWorker.perform_async(user.id)
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

  def self.create_playlists_with_id(playlists, user_id)
    return playlists["items"].map{|p| create_from_spotify_with_id(p, user_id)}
  end

  def self.create_from_spotify_with_id(spotify_playlist, user_id)
    find_or_create_by(spotify_id: spotify_playlist["id"]) do |p|
      p.name = spotify_playlist["name"]
      p.uri = spotify_playlist["uri"]
      p.description = spotify_playlist["description"]
      p.tracks_url = spotify_playlist["tracks"]["href"]
      p.user_id = user_id
    end
  end


end
