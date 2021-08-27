class SourcePlaylist::SongsWorker
  include Sidekiq::Worker

  def perform(playlist_id, token, offset)
    playlist = SpotifySourcePlaylist.find(playlist_id)
    total = playlist.fetch_songs(token, offset)
    SourcePlaylist::IncrementRequestsWorker.perform_async(playlist_id, total)
    if offset < total
      SourcePlaylist::SongsWorker.perform_async(playlist_id, token, offset + 100)
    end
  end
end
