source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

source "https://gems.bridgetownrb.com" do
  gem "bridgetown", "~>2"
  gem "bridgetown-feed"
  gem "bridgetown-seo-tag"
end
gem "bridgetown-svg-inliner"
gem "bridgetown-sitemap"

gem "reading", github: "fpsvogel/reading"
gem "chartkick"
gem "rinku" # There's also the more maintained https://github.com/tenderlove/rails_autolink but Rinku is faster.
gem "sanitize"
gem "dropbox_api"

group :development do
  gem "puma"
  gem "debug"
end
