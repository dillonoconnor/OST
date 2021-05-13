require 'open-uri'

class Playlist < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :tracks, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_many :comments, dependent: :destroy
  has_one_attached :playlist_image, dependent: :destroy


  scope :chronological, -> { order("created_at desc") }
  scope :popular, -> { left_joins(:likes).select('playlists.*, COUNT(playlist_id) AS count_of_likes').group('playlists.id').order('count_of_likes DESC') }

  def self.prepare_playlist(params)
    playlist = Playlist.new
    spotify_object = playlist.get_spotify_object(params)
    playlist.populate_attributes(spotify_object, params)
    spotify_object.tracks.each do|track|
      playlist.tracks.new(
        title: track.name, 
        artist: track.artists.first.name
      )
    end
    playlist
  end

  def self.search_playlists(playlist)
    RSpotify::Playlist.search(playlist)
  end

  def attach_image(params)
    spotify_object = get_spotify_object(params)
    open(spotify_object.images.first['url']) do |file|
      playlist_image.attach(io: file, filename: "#{name}_playlist_image")
    end
  end

  def populate_attributes(spotify_object, params)
    self.name = spotify_object.name.split("OST")[0].strip
    self.spotify_id = params[:playlist_id] ? params[:playlist_id] : params[:playlist][:id].split("spotify:playlist:").first
  end

  def get_spotify_object(params)
    if params[:playlist]
      id = params[:playlist][:id].split("spotify:playlist:")[1]
    elsif params[:playlist_id]
      id = params[:playlist_id]
    end
    RSpotify::Playlist.find_by_id(id)
  end
end
