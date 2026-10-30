class SitePage < Data.define(:key, :path, :label, :title, :lead, :nav)
  extend SiteContent.collection(:pages, lead: nil, nav: true)

  def self.navigation
    all.select(&:nav)
  end

  def url
    "/#{path}"
  end
end
