class DestinationPlaylist < ApplicationRecord
  belongs_to :user

  def add_songs(songs, token)
    i = 0
    songs = songs
    while songs.length > i do
      body = {"uris": songs.slice(i, 100).map{|song| song.uri}}.to_json
      response = `curl -i -X POST \
      https://api.spotify.com/v1/playlists/#{spotify_id}/tracks \
      -H "Authorization: Bearer #{token}" \
      -H "Accept: application/json" \
      -H 'Content-Type: application/json' \
      -d '#{body}'
      `
      i = i + 100
    end
  end

  def unfollow_playlist(token)
    `curl -X DELETE "https://api.spotify.com/v1/playlists/#{spotify_id}/followers" -H "Authorization: Bearer #{token}"`
    self.destroy
  end

  def self.create_from_response(response, year, user)
    find_or_create_by(spotify_id: response["id"]) do |p|
      p.name = response["name"]
      p.description = response["description"]
      p.href = response["href"]
      p.uri = response["uri"]
      p.user = user
      p.year = year
    end
  end

  def self.create_user_playlists(user)
    token = user.get_new_token
    grouped_by_year = Song.by_year(user.songs.not_compilation)
    years = grouped_by_year.keys.select{|key| key != "not_sorted"}.sort_by{|a, b| b.to_i - a.to_i}
    years.each do |year|
      playlist = user.make_playlist(grouped_by_year[year], year, token)
      playlist.add_songs(grouped_by_year[year], token)
    end
  end

end
