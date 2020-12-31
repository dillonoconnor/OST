class Playlist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :tracks, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  scope :chronological, -> { order("created_at desc") }
  scope :popular, -> { left_outer_joins(:likes).order('count(playlist_id) DESC').group('name')}
end
