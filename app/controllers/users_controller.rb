class UsersController < ApplicationController

  def new

  end

  def auth
    token = User.get_access_token(params[:code])
    user = User.create_from_access_token(token)
    render 'auth'
    # byebug
    SpotifySourcePlaylist.grab_all_playlists(user, token)
    user.spotify_source_playlists.each{|p| p.get_songs(token)}
    DestinationPlaylist.create_user_playlists(user, token)
    puts "hello"
  end
end