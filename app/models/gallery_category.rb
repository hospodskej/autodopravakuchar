class GalleryCategory < Data.define(:key, :title, :description, :photos)
  extend SiteContent.collection(:gallery)

  def initialize(key:, photos:, **attrs)
    photos = photos.map { |photo| SiteContent.build(GalleryPhoto, photo, featured: false, category: key) }.freeze
    super(key:, photos:, **attrs)
  end
end
