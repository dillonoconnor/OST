class Follow < ApplicationRecord
  belongs_to :playlist
  belongs_to :user

  validates :playlist_id, uniqueness: true
end
