class SpotifyApi

  def self.get(user, endpoint)
    JSON.parse(`curl -H "Authorization: Bearer #{user.get_new_token}" https://api.spotify.com/v1#{endpoint}`)
  end

  def self.get_with_token(token, endpoint)
    res = `curl -H "Authorization: Bearer #{token}" https://api.spotify.com/v1#{endpoint}`
    if res != ""
      JSON.parse(res)
    else
      res = `curl -H "Authorization: Bearer #{token}" https://api.spotify.com/v1#{endpoint}`
      if res != ""
        JSON.parse(res)
      else
        puts "Giving up on #{endpoint}"
      end
    end
  end

end
