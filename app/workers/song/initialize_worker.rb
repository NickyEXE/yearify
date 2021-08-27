class Song::InitializeWorker
  include Sidekiq::Worker

  def perform(user_id, total_playlists)
    user = User.find(user_id)
    if user.spotify_source_playlists.size == total_playlists
      user.get_all_songs
    else
      Song::InitializeWorker.perform_async(user_id, total_playlists)
    end
  end
end
