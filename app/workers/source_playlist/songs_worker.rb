class SourcePlaylist::SongsWorker
  include Sidekiq::Worker

  def perform(playlist_id, token, offset)
    playlist = SpotifySourcePlaylist.find(playlist_id)
    total = playlist.fetch_songs(token, offset)
    if offset + 100 <= total
      SourcePlaylist::SongsWorker.perform_async(playlist_id, token, offset + 100)
    end
  end
end
