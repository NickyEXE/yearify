class SourcePlaylist::SongsWorker
  include Sidekiq::Worker

  def perform(playlist_id, token, offset)
    playlist = SpotifySourcePlaylist.find(playlist_id)
    total = playlist.fetch_songs(token, offset)
    if !playlist.needed_requests
      playlist.update(needed_requests: total/100 + 1, total_requests: playlist.total_requests + 1)
    if offset < total
      SourcePlaylist::SongsWorker.perform_async(playlist_id, token, offset + 100)
    end
  end
end
