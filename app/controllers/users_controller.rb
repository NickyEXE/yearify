class UsersController < ApplicationController

  def new

  end

  def auth
    token = User.get_access_token(params[:code])
    user = User.create_from_access_token(token)
    grouped_by_year = Song.by_year(user.songs)
    playlist = user.make_playlist(grouped_by_year[1983], 1983, token)
    playlist.add_songs(grouped_by_year[1983], token)
    # user.spotify_source_playlists.last.get_songs(token)
    # SpotifySourcePlaylist.grab_all_playlists(user, token)
    # user.spotify_source_playlists.each{|p| p.get_songs(token)}
  end
end
