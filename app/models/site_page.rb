class SitePage < Data.define(:key, :path, :label, :title, :meta_title, :lead, :description, :nav)
  extend SiteContent.collection(:pages, meta_title: nil, lead: nil, description: nil, nav: true)

  def self.navigation
    all.select(&:nav)
  end

  # Not listed in config/site.yml: rendered for unknown URLs, never linked or indexed.
  def self.not_found
    new(key: "not_found", path: "404", label: "Stránka nenalezena", title: "Stránka nenalezena", meta_title: nil,
        lead: "Tahle stránka neexistuje nebo byla přesunuta.", description: nil, nav: false)
  end

  def url
    "/#{path}"
  end

  def document_title
    [ meta_title || title, Company.current.name ].join(" – ")
  end
end
