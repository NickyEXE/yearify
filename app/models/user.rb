class User < ApplicationRecord
  has_many :spotify_source_playlists, dependent: :destroy
  has_many :songs, dependent: :destroy

  def make_playlist(songs, year, token){

  }

  def self.get_access_token(code)
    token = Base64.strict_encode64(ENV["SPOTIFY_KEY"] + ":" + ENV["SPOTIFY_SECRET"])
    response = JSON.parse(`curl -X POST \
    https://accounts.spotify.com/api/token \
    -H 'Accept: */*' \
    -H 'Authorization: Basic #{token}' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d 'code=#{code}&grant_type=authorization_code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Fauth'`)
    return response['access_token']
  end

  def self.create_from_access_token(access_token)
    user_data = JSON.parse(`curl -H "Authorization: Bearer #{access_token}" https://api.spotify.com/v1/me`)
    user = User.find_or_create_by(email: user_data['email']) do |u|
      u.display_name = user_data['display_name']
      u.uri = user_data['uri']
    end
    return user
  end
end
