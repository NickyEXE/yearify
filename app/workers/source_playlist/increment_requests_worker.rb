class SourcePlaylist::IncrementRequestsWorker
  include Sidekiq::Worker

  def perform(playlist_id, total)
    # Do something
    playlist = SpotifySourcePlaylist.find(playlist_id)
    playlist.with_lock do
      if !playlist.needed_requests
        playlist.update!(needed_requests: total/100 + 1, total_requests: 1)
      else
        playlist.update!(total_requests: playlist.total_requests + 1)
      end
    end
  end
end
2
