class Song < ApplicationRecord
  belongs_to :spotify_source_playlist
  belongs_to :user

  scope :not_compilation, -> {where.not(album_type: "compilation").or(Song.where(album_type: nil))}
  scope :in_year, -> (year){where("release_date >= ? AND release_date <= ?", DateTime.new(year), DateTime.new(year + 1))}

  def get_self
    SpotifyApi.get(user, "/tracks/#{spotify_id}")
  end

  def self.by_year(songs)
    songs.group_by{|s| s.release_date ? s.release_date.year : "not_sorted"}
  end

end
