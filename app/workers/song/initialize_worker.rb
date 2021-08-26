class Song::InitializeWorker
  include Sidekiq::Worker

  def perform(user_id)
    User.find(user_id).get_all_songs
  end
end
