class UsersController < ApplicationController

  def new

  end

  def auth
    token = Base64.strict_encode64(ENV["SPOTIFY_KEY"] + ":" + ENV["SPOTIFY_SECRET"])
    response = JSON.parse(`curl -X POST \
    https://accounts.spotify.com/api/token \
    -H 'Accept: */*' \
    -H 'Authorization: Basic #{token}' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d 'code=#{params[:code]}&grant_type=authorization_code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth'`)
    user = JSON.parse(`curl -H "Authorization: Bearer #{response['access_token']}" https://api.spotify.com/v1/me`)
    byebug
  end
end
