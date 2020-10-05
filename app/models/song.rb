class Song < ApplicationRecord
  belongs_to :spotify_source_playlist
  belongs_to :user

  def self.by_year(songs)
    songs.group_by{|s| s.release_date ? s.release_date.year : "not_sorted"}
  end

end
