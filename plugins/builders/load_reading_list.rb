require "reading"
require "dropbox_api"
require "debug"

class Builders::LoadReadingList < SiteBuilder
  def build
    hook :site, :post_read do |site|
      generator do
        local_filepath = config.reading.local_filepaths.find { File.exist? _1 }

        if local_filepath.nil? && !dropbox_access?
          site.data.reading_stats = {}
          site.data.reading_list = []
          site.data.reading_genres = []
          site.data.reading_ratings = []
          config.reading.types = {}
        else
          items = Reading.parse(
            lines: my_dropbox_file,
            # If my_dropbox_file is nil, then the local file path is used instead.
            path: local_filepath,
            error_handler: ->(e) { puts "Skipped a row due to a parsing error: #{e}" }
          )

          site.data.reading_stats = get_stats(items)

          filtered_items = Reading.filter(
            items:,
            minimum_rating: 4,
            excluded_genres: config.reading.excluded_genres || [],
            status: [:done, :in_progress]
          )

          site.data.reading_list = filtered_items.map(&:view).reverse

          site.data.reading_genres = uniq_of_attribute(:genres, site.data.reading_list, sort_by: :frequency)
          site.data.reading_ratings = uniq_of_attribute(:rating, site.data.reading_list, sort_by: :value)

          config_to_save = Reading
            .config[:item][:view]
            .slice(:types, :minimum_rating_for_star)

          config.reading.merge!(config_to_save)
        end
      end
    end
  end

  private

  # My reading.csv file on Dropbox, or nil if it is inaccessible.
  # @return [File, nil]
  def my_dropbox_file
    return nil unless dropbox_access?
    # environment variables come from Netlify settings.
    token_hash = {
      token_type: "bearer",
      access_token: ENV["MY_DROPBOX_ACCESS_TOKEN"],
      refresh_token: ENV["MY_DROPBOX_REFRESH_TOKEN"]
    }
    authenticator = DropboxApi::Authenticator.new(ENV["MY_DROPBOX_APP_KEY"], ENV["MY_DROPBOX_APP_SECRET"])
    authenticated_token = OAuth2::AccessToken.from_hash(authenticator, token_hash)
    authenticated_token.refresh!
    client = DropboxApi::Client.new(access_token: authenticated_token)
    uri = URI(client.get_temporary_link(config.reading.dropbox_filepath).link)
    Net::HTTP.get(uri)
  end

  # Whether this build has access to my Dropbox account. (There is no access
  # when building locally, only when deploying.)
  # @return [Boolean]
  def dropbox_access?
    config.reading.dropbox_filepath &&
      ENV["MY_DROPBOX_ACCESS_TOKEN"] &&
      ENV["MY_DROPBOX_REFRESH_TOKEN"] &&
      ENV["MY_DROPBOX_APP_KEY"] &&
      ENV["MY_DROPBOX_APP_SECRET"]
  end

  # Queries for statistics on the given Items, and saves the results to site data.
  # @param items [Array<Item>]
  def get_stats(items)
    stats = {}

    stats[:amount_by_genre_favorites] =
      Reading.stats(input: "amount by genre rating>3", items:)
        .transform_values(&:to_i)
        .to_a
        .filter { |_genre, amount| amount > 1000 }
        .sort_by { |_genre, amount| amount }
        .reverse
        .to_h

    stats[:genres_by_year] =
      Reading.stats(input: "amount by year, genre", items:)
        .transform_values { |genre_counts|
          top_4 = genre_counts
            .transform_values(&:to_i)
            .max_by(4, &:last)
            .to_h

          other_sum = genre_counts
            .transform_values(&:to_i)
            .except(*top_4.keys)
            .values
            .sum

          top_4.merge("other" => other_sum)
        }
        .delete_if { |year, _genre_counts| year < 2017 }
        .flat_map { |year, genre_counts| genre_counts.map { |genre, count| [genre, [year, count]] } }
        .group_by(&:first)
        .transform_values { _1.map(&:last).to_h }

    stats[:rating_counts] =
      Reading.stats(input: "total items by rating", items:)

    stats[:top_experiences] =
      Reading.stats(input: "top 10 experiences", items:)

    stats[:top_lengths] =
      Reading.stats(input: "top 10 lengths status=done progress=100%", items:)
        .to_h
        .transform_values(&:to_i)

    stats[:top_notes] =
      Reading.stats(input: "top 10 notes", items:)

    stats[:top_speeds] =
      Reading.stats(input: "top 10 speeds", items:)
        .to_h
        .transform_values { |speed| (speed[:amount] / speed[:days].to_f).to_i }

    stats
  end

  # The unique values of an attribute across all items.
  # @param sort_by [Symbol] :frequency or :value
  # @return [Array]
  def uniq_of_attribute(attribute, items, sort_by:)
    all = items.flat_map { |item|
      item.send(attribute).presence
    }.compact

    all =
      if sort_by == :frequency
        all
          .group_by(&:itself)
          .sort_by { |value, duplicates| duplicates.count }
          .reverse
          .to_h
          .keys
      else
        all.uniq
      end

    if sort_by == :value
      all = all.sort
    end

    all
  end
end
