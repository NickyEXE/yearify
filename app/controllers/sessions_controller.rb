class SessionsController < ApplicationController

  def new

  end

  def create
    access_hash = User.get_access_token(params[:code])
    token = access_hash['access_token']
    user = User.create_from_access_token(access_hash)
    session[:id] = user.id
    redirect_to user
    puts "hello"
  end
end
