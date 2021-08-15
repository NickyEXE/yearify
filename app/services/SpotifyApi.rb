class SpotifyApi

  def self.get(user, endpoint)
    JSON.parse(`curl -H "Authorization: Bearer #{user.get_new_token}" https://api.spotify.com/v1#{endpoint}`)
  end

end
