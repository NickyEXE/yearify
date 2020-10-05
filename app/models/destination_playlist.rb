class DestinationPlaylist < ApplicationRecord
  belongs_to :user

  def self.create_from_response(response, year, user)
    find_or_create_by(spotify_id: response["id"]) do |p|
      p.name = response["name"]
      p.description = response["description"]
      p.href = response["href"]
      p.uri = response["uri"]
      p.user = user
      p.year = year
    end
  end
end
