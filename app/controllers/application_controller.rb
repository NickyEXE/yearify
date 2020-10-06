class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by_id(session[:id])
  end

  def authorize
    redirect_to new_session_path unless @current_user
  end

end
