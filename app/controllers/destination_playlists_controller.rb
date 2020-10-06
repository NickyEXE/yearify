class DestinationPlaylistsController < ApplicationController
  before_action :authorize

  def create
    @current_user.generate_all_playlists
    redirect_to @current_user
  end

end
