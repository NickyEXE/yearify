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
    # you can remove this create_playlists I think?
    # We make one extraneous request, but starting the offset at 20 below led to 20 missing playlists so something is going wrong here.
    create_playlists(first_playlists, user)
    total_playlists = first_playlists["total"]
    offset = 0
    while offset <= total_playlists do
      SourcePlaylist::ImportWorker.perform_async(token, offset, user.id)
      offset = offset + 20
    end
    # update to make wait for total_playlists to match
    Song::InitializeWorker.perform_async(user.id, total_playlists)
  end

  def self.get_by_token_and_offset(token, offset)
    SpotifyApi.get_with_token(token, "/me/playlists?offset=#{offset}")
  end

  def self.create_playlists(playlists, user_id)
    return playlists["items"].map{|p| create_from_spotify(p, user_id)}
  end

  def self.create_from_spotify(spotify_playlist, user_id)
    find_or_create_by(spotify_id: spotify_playlist["id"], user_id: user_id) do |p|
      p.name = spotify_playlist["name"]
      p.uri = spotify_playlist["uri"]
      p.description = spotify_playlist["description"]
      p.tracks_url = spotify_playlist["tracks"]["href"]
      # p.user_id = user_id
    end
  end

end
