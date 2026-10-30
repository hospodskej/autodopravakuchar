class Service < Data.define(:title, :summary, :items, :photo)
  extend SiteContent.collection(:services, items: [])

  def photo
    GalleryPhoto.find_by!(file: super)
  end
end
