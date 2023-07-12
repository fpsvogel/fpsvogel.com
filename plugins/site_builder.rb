class SiteBuilder < Bridgetown::Builder
  # write builders which subclass SiteBuilder in plugins/builders
end

Bridgetown::RubyTemplateView::Helpers.include Chartkick::Helper
