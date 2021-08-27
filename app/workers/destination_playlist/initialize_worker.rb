class DestinationPlaylist::InitializeWorker
  include Sidekiq::Worker

  def perform(user_id)
    if User.find(user_id).all_songs_imported?
      DestinationPlaylist.create_user_playlists(user_id)
    else
      DestinationPlaylist::InitializeWorker.perform_in(30.seconds, user_id)
    end
  end
end
