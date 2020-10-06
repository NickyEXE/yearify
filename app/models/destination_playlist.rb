class DestinationPlaylist < ApplicationRecord
  belongs_to :user

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

  def add_songs(songs, token)
    body = {"uris": songs.map{|song| song.uri}}.to_json
    response = `curl -i -X POST \
    https://api.spotify.com/v1/playlists/#{spotify_id}/tracks \
    -H "Authorization: Bearer #{token}" \
    -H "Accept: application/json" \
    -H 'Content-Type: application/json' \
    -d '#{body}'
    `
  end

  def destroy_playlist(token)
    `curl -X DELETE "https://api.spotify.com/v1/playlists/#{spotify_id}/followers" -H "Authorization: Bearer #{token}"`
  end
end
