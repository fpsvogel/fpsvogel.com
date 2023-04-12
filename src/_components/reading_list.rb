class ReadingList < Bridgetown::Component
  def initialize
    @site = Bridgetown::Current.site
    @list = @site.data.reading
    @genres = @site.data.reading_genres
    @ratings = @site.data.reading_ratings
    @config = @site.config.reading
  end
end
