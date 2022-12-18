require "reading/csv"
require "dropbox_api"
require "debug"

class Builders::LoadReadingList < SiteBuilder
  CONFIG_DEFAULTS = {
    reading: {
      types: {
        book: "📕"
      },
      # # if you want to override the default set of format names and/or emojis.
      # # the defaults can be seen here:
      # # https://github.com/fpsvogel/reading-csv/blob/main/lib/reading/csv/config.rb
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
  }

  def build
    hook :site, :post_read do |site|
      generator do
        site.data.reading = load_from_csv
                            .then { |list| save_to_data(list) }
        site.data.reading = add_type_emojis(site.data.reading)
                            .then { |list| add_stars(list) }
        site.data.reading_genres = uniq_of_attribute(:genres, site.data.reading, sort_by: :frequency)
        site.data.reading_ratings = uniq_of_attribute(:rating, site.data.reading, sort_by: :value)
        site.data.reading_config_defaults = config.reading
      end
    end
  end

  def load_from_csv
    items = select_by_rating(parse_items)
      .then { |items| select_by_genre(items) }
      .then { |items| select_done_or_in_progress(items) }
      .then { |items| simplify(items) }
      # TODO not necessary if I made sure the types were all strings
      .then { |items| items.map { |item| item.update(type: item[:type].to_s) } }

    sort_by_date(items)
    items
  end

  def parse_items(custom_config: {})
    if config.reading.formats
      custom_config[:item] ||= {}
      custom_config[:item][:formats] = to_normal_hash(config.reading.formats)
    end

    custom_config[:csv] ||= {}
    custom_config[:csv][:skip_compact_planned] = true

    csv = Reading::CSV.new(
      my_dropbox_file,
      # If my_dropbox_file is nil, then the local file path is used instead.
      path: config.reading.local_filepath,
      config: custom_config,
    )

    csv.parse
  end

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

  def dropbox_access?
    config.reading.dropbox_filepath &&
      ENV["MY_DROPBOX_ACCESS_TOKEN"] &&
      ENV["MY_DROPBOX_REFRESH_TOKEN"] &&
      ENV["MY_DROPBOX_APP_KEY"] &&
      ENV["MY_DROPBOX_APP_SECRET"]
  end

  def select_by_rating(items)
    return items if config.reading.minimum_rating.nil?
    items.select do |item|
      if item[:rating]
        item[:rating] >= (config.reading.minimum_rating || 0)
      end
    end
  end

  def select_by_genre(items)
    return items if config.reading.excluded_genres.nil? || config.reading.excluded_genres.empty?

    items.select do |item|
      overlapping = item[:genres] & config.reading.excluded_genres
      overlapping.empty?
    end
  end

  def select_done_or_in_progress(items)
    items.select { |item|
      item[:experiences].any? { |experience|
        experience[:spans]
      }
    }
  end

  def simplify(items)
    items.map do |item|
      first_isbn, first_url, format, extra_info = first_source_info(item)
      if first_isbn
        url_from_isbn = "https://www.goodreads.com/book/isbn?isbn=#{first_isbn}"
      end
      series_and_extras =
        item[:series].map do |series|
          if series[:volume]
            "#{series[:name]}, ##{series[:volume]}"
          else
            "in #{series[:name]}"
          end
        end + (extra_info || [])
      name = "#{item[:author] + " – " if item[:author]}#{item[:title]}" \
             "#{" 〜 " + (series_and_extras).join(" 〜 ") unless series_and_extras.empty?}"
      date = item[:experiences].last[:spans].last[:dates]&.end
      {
        id: first_isbn || first_url,
        rating: item[:rating],
        type: format_to_type(format) ||
              format ||
              config.reading.default_type,
        name: name,
        site: url_from_isbn || first_url,
        genres: item[:genres],
        date: date&.strftime("%Y-%m-%d") || config.reading.in_progress_string,
        date_in_words: date&.strftime("%B %e") ||
                       config.reading.in_progress_string.capitalize,
        reread?: item[:experiences].map { |experience| experience[:date_finished] }.compact.count > 1,
        groups: item[:experiences].map { |experience| experience[:group] }.compact.presence,
        blurb: item[:notes]
                .find { |note| note[:blurb] }
                &.dig(:content),
        notes: item[:notes]
                .select { |note| !note[:private] && !note[:blurb] }
                .map { |note| note[:content] }
                .presence,
      }
    end
  end

  def first_source_info(item)
    first_isbn, format, extra_info =
      item[:variants].map do |variant|
        [variant[:isbn], variant[:format], variant[:extra_info]]
      end
      .reject { |isbn, format, extra_info| isbn.nil? }
      .first
    unless first_isbn
      first_url, format, extra_info =
        item[:variants].map do |variant|
          url = variant[:sources].map { |source| source[:url] }.compact.first
          [url, variant[:format], variant[:extra_info]]
        end
        .reject { |url, format, extra_info| url.nil? }
        .first
    end
    [first_isbn, first_url, format, extra_info]
  end

  def format_to_type(format)
    formats_to_types[format]
  end

  def formats_to_types
    @formats_to_types ||=
      config.reading.types_from_formats.flat_map do |type, formats|
        formats.zip([type] * formats.count)
      end.to_h
        .transform_keys(&:to_sym)
        .transform_values(&:to_sym)
  end

  # returns items sorted by date (most recent first) then name (alphabetical)
  def sort_by_date(items)
    in_progress = items.select { |item| item[:date].nil? }
                       .sort_by { |item| item[:name].downcase }
    done = items - in_progress
    done = done.sort do |item_a, item_b|
      case item_a[:date] <=> item_b[:date]
      when -1 then 1
      when 1 then -1
      else
        item_a[:name].downcase <=> item_b[:name].downcase
      end
    end
    in_progress + done
  end

  def add_type_emojis(items)
    formats = config.reading.formats || Reading::Config.new.hash[:item][:formats]

    items.map do |item|
      item.merge({
        type_emoji: config.reading.types[item.fetch(:type)] ||
                    formats[item.fetch(:type)] })
    end
  end

  def add_stars(items)
    if config.reading.star_for_rating_minimum
      items.map do |item|
        item.merge({ star: if item.fetch(:rating) >= config.reading.star_for_rating_minimum
                            "⭐"
                          else
                            ""
                          end })
      end
    else
      items.map do |item|
        item.merge({ star: nil })
      end
    end
  end

  # returns the unique varieties of an attribute across all items.
  # sort_by: :frequency or :value
  # convert: type conversion, such as :to_s
  def uniq_of_attribute(attribute, items, sort_by:, convert: nil)
    all = items.flat_map do |item|
      item.send(attribute).presence
    end.compact
    if sort_by == :frequency
      all = all.group_by(&:itself)
        .sort_by { |value, duplicates| duplicates.count }
        .reverse.to_h.keys
    else
      all = all.uniq
    end
    if convert
      all = all.map do |value|
        value.send(convert)
      end
    end
    if sort_by == :value
      all = all.sort
    end
    all
  end

  def save_to_data(list)
    File.write("src/_data/reading.yml", to_safe_hashes(list).to_yaml)
    list
  end

  # transforms an array of hashes so that symbol keys become strings, so they
  # can be written to YAML that can be read with YAML.safe_load (or YAML.load).
  def to_safe_hashes(hashes)
    hashes.map do |item|
      item.transform_keys(&:to_s)
          .transform_values do |v|
            if v.is_a? Symbol
              v.to_s
            else
              v
            end
          end
    end
  end

  # the reverse of to_safe_hashes (above) and removes dot syntax.
  def to_normal_hash(hash)
    hash.to_h.transform_keys(&:to_sym)
  end

  # def with_dot_syntax(hashes)
  #   hashes.each do |hash|
  #     hash.define_singleton_method(:method_missing) do |m, *args, **kwargs, &block|
  #       if include?(m)
  #         fetch(m)
  #       else
  #         super(m, *args, **kwargs, &block)
  #       end
  #     end
  #     hash.define_singleton_method(:respond_to_missing?) do |m, *args, **kwargs|
  #       include?(m) || super(m, *args, **kwargs, &block)
  #     end
  #   end
  # end

  # def load_from_data
  #   if File.exist?("src/_data/reading.yml")
  #     raw = YAML.load(File.read("src/_data/reading.yml"))
  #     from_safe_hashes(raw)
  #   end
  # end
end
