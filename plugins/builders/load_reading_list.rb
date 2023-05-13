require "reading"
require "dropbox_api"
require "debug"

class Builders::LoadReadingList < SiteBuilder
  def build
    hook :site, :post_read do |site|
      generator do
        items = Reading.parse(
          lines: my_dropbox_file,
          # If my_dropbox_file is nil, then the local file path is used instead.
          path: config.reading.local_filepath,
          config: { skip_compact_planned: true },
        )

        filtered_items = Reading.filter(
          items:,
          minimum_rating: 4,
          excluded_genres: config.reading.excluded_genres || [],
          status: [:done, :in_progress],
        )

        site.data.reading = filtered_items.map(&:view).reverse

        site.data.reading_genres = uniq_of_attribute(:genres, site.data.reading, sort_by: :frequency)
        site.data.reading_ratings = uniq_of_attribute(:rating, site.data.reading, sort_by: :value)

        config_to_save = Reading
          .default_config[:item][:view]
          .slice(:types, :minimum_rating_for_star)

        config.reading.merge!(config_to_save)
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


  # The unique values of an attribute across all items.
  # @param sort_by [Symbol] :frequency or :value
  # @return [Array]
  def uniq_of_attribute(attribute, items, sort_by:)
    all = items.flat_map { |item|
      item.send(attribute).presence
    }.compact

    if sort_by == :frequency
      all = all
        .group_by(&:itself)
        .sort_by { |value, duplicates| duplicates.count }
        .reverse
        .to_h
        .keys
    else
      all = all.uniq
    end

    if sort_by == :value
      all = all.sort
    end

    all
  end
end
