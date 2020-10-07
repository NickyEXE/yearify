class DestinationPlaylistsController < ApplicationController
  before_action :authorize

  def create
    if @current_user.destination_playlists.count > 0
      render 'error'
    else
      @current_user.generate_all_playlists
      redirect_to @current_user
    end
  end

  def destroy_all
    @current_user.unfollow_all_playlists
    redirect_to @current_user
  end

end
