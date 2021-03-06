class Playlist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  
  has_many :tracks, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :comments, dependent: :destroy

  scope :chronological, -> { order("created_at desc") }
  scope :popular, -> { left_joins(:likes).select('playlists.*, COUNT(playlist_id) AS count_of_likes').group('playlists.id').order('count_of_likes DESC') }
end
