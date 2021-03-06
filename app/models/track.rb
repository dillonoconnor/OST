class Track < ApplicationRecord
  belongs_to :playlist, counter_cache: true
end
