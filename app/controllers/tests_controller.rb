class TestsController < ApplicationController
  before_action :authorize

  def index
  end

  def source_playlists
    SpotifySourcePlaylist.grab_all_playlists(@current_user)
    redirect_to @current_user
  end

  def songs
    Song::InitializeWorker.perform_async(@current_user.id)
    redirect_to @current_user
  end

  def destination_playlists
    DestinationPlaylist::InitializeWorker.perform_async(@current_user.id)
    redirect_to @current_user
  end

end
