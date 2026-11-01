class GalleryPhoto < Data.define(:file, :alt, :featured, :category)
  extend SiteContent::Finders

  def self.all
    @all ||= GalleryCategory.all.flat_map(&:photos).freeze
  end

  def self.featured
    all.select(&:featured)
  end

  def path
    "technika/#{file}"
  end

  def thumbnail_path
    "technika/nahled/#{file}"
  end

  def small_path
    "technika/male/#{file}"
  end
end
