class TestsController < ApplicationController
  before_action :authorize

  def source_playlists
    SpotifySourcePlaylist.grab_all_playlists(@current_user)
    redirect_to @current_user
  end

  def songs
    Song::InitializeWorker.perform_async(user.id)
    redirect_to @current_user
  end

end
