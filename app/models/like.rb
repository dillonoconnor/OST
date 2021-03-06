class Like < ApplicationRecord
  belongs_to :user
  belongs_to :playlist, counter_cache: true
end
