class DestinationPlaylist::InitializeWorker
  include Sidekiq::Worker

  def perform(user_id)
    # Do something
    DestinationPlaylist.create_user_playlists(user_id)
  end
end
