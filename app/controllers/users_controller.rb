class UsersController < ApplicationController

  def new

  end

  def auth
    access_hash = User.get_access_token(params[:code])
    token = access_hash['access_token']
    user = User.create_from_access_token(access_hash)
    render 'auth'
    SpotifySourcePlaylist.grab_all_playlists(user)
    user.get_all_songs
    DestinationPlaylist.create_user_playlists(user)
    puts "hello"
  end
end
