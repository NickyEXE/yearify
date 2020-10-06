class UsersController < ApplicationController
  before_action :authorize

  def show
    user = User.find(session[:id])
  end
end
