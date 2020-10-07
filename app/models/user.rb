class User < ApplicationRecord
  has_many :spotify_source_playlists, dependent: :destroy
  has_many :destination_playlists, dependent: :destroy
  has_many :songs, dependent: :destroy
  validates :email, presence: true

  def generate_all_playlists
    unless destination_playlists.length > 0
      SpotifySourcePlaylist.grab_all_playlists(self)
      get_all_songs
      DestinationPlaylist.create_user_playlists(self)
    end
  end

  def get_all_songs
    token = get_new_token
    spotify_source_playlists.each{|p| p.get_songs(token)}
  end

  def unfollow_all_playlists
    token = get_new_token
    destination_playlists.each{|p| p.unfollow_playlist(token)}
  end

  def make_playlist(songs, year, token)
    response = JSON.parse(`curl -X POST \
    https://api.spotify.com/v1/users/#{self.spotify_id}/playlists \
    -H 'Accept: */*' \
    -H 'Authorization: Bearer #{token}' \
    -H 'Content-Type: application/json' \
    -d '{"name":"All Your Songs From #{year}", "description":"Generated by Nicky Dovers Spotify Yearifier", "public":false}'
    `)
    DestinationPlaylist.create_from_response(response, year, self)
  end

  def get_new_token
    token = Base64.strict_encode64(ENV["SPOTIFY_KEY"] + ":" + ENV["SPOTIFY_SECRET"])
    response = JSON.parse(`curl -H "Authorization: Basic #{token}" -d grant_type=refresh_token -d refresh_token=#{self.refresh_token} https://accounts.spotify.com/api/token`)
    return response["access_token"]
  end

  def self.get_access_token(code)
    token = Base64.strict_encode64(ENV["SPOTIFY_KEY"] + ":" + ENV["SPOTIFY_SECRET"])
    response = JSON.parse(`curl -X POST \
    https://accounts.spotify.com/api/token \
    -H 'Accept: */*' \
    -H 'Authorization: Basic #{token}' \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d 'code=#{code}&grant_type=authorization_code&redirect_uri=#{ENV['ROOT']}auth/'`)
    return response
  end

  def self.create_from_access_token(access_hash)
    user_data = JSON.parse(`curl -H "Authorization: Bearer #{access_hash['access_token']}" https://api.spotify.com/v1/me`)
    user = User.find_or_create_by(email: user_data['email']) do |u|
      u.display_name = user_data['display_name']
      u.uri = user_data['uri']
      u.spotify_id = user_data['id']
      u.refresh_token = access_hash["refresh_token"]
    end
    return user
  end
end
