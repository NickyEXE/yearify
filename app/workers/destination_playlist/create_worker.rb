class DestinationPlaylist::CreateWorker
  include Sidekiq::Worker

  def perform(user_id, token, year)
    # Do something
    user = User.find(user_id)
    playlist = user.make_playlist(year, token)
    playlist.add_songs(user.songs.in_year(year).not_compilation, token)
  end
end
