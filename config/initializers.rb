require "chartkick"

Bridgetown.configure do |config|
  init :"bridgetown-seo-tag"
  init :"bridgetown-feed"
  init :"bridgetown-svg-inliner"
  init :"bridgetown-sitemap"
  init :rinku
end
