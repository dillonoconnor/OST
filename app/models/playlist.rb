class Playlist < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :tracks, dependent: :destroy
  has_many :follows, dependent: :destroy

  scope :chronological, -> { order("created_at desc") }
end
