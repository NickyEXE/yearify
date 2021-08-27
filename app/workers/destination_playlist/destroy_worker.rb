class DestinationPlaylist::DestroyWorker
  include Sidekiq::Worker

  def perform(id, token)
    playlist = DestinationPlaylist.find(id)
    `curl -X DELETE "https://api.spotify.com/v1/playlists/#{playlist.spotify_id}/followers" -H "Authorization: Bearer #{token}"`
    playlist.destroy
  end
end
