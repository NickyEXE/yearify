class SourcePlaylist::ImportWorker
  include Sidekiq::Worker

  def perform(token, offset, user_id)
    playlists = SpotifySourcePlaylist.get_by_token_and_offset(token, offset)
    SpotifySourcePlaylist.create_playlists(playlists, user_id)
  end
end
