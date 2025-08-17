require "chartkick"
require "rinku"
require "sanitize"

Bridgetown.configure do |config|
  init :"bridgetown-seo-tag"
  init :"bridgetown-feed"
  init :"bridgetown-svg-inliner"
  init :"bridgetown-sitemap"
end
