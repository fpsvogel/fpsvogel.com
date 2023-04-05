Bridgetown.configure do |config|
  init :"bridgetown-seo-tag"
  init :"bridgetown-feed"
  init :"bridgetown-svg-inliner"
  init :"bridgetown-sitemap"
  init :"rinku"

  config.reading = {
    types: {
      book: "📕"
    },
    # # if you want to override the default set of format names and/or emojis.
    # # the defaults can be seen here:
    # # https://github.com/fpsvogel/reading-csv/blob/main/lib/reading/config.rb
    # formats: {
    #   print:      "📄",
    #   ebook:      "📱",
    #   audiobook:  "🎧"
    # },
    show_types_key: true,
    show_sort: true,
    types_from_formats: {
      # convert reading.csv formats (right) into reading list types (left).
      book: [:print, :ebook, :audiobook, :pdf]
    },
    rating_scale: 5, # the highest possible rating. must be an integer.
    # star_for_rating_minimum: 5, # items rated this or above get a star.
    #                             # without this, number ratings appear instead.
    # minimum_rating: 4, # exclude ratings below this. must be an integer.
    # excluded_genres: ["top secret", "cat videos"]
    default_type: :book,
    group_emoji: "🤝🏼",
    in_progress_string: "in progress"
  }
end
