module PlaylistsHelper
  def youtube_search_link(track)
    link_to track.title, 
      "https://www.youtube.com/results?search_query=#{track.title}+#{track.artist}",
      target: :_blank
  end

  def pretty_title(title)
    title.split.map(&:upcase).join(' ')
  end
end
