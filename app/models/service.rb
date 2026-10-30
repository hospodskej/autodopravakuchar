class Service < Data.define(:title, :summary, :items, :photo)
  extend SiteContent.collection(:services, items: [])

  def number
    format("%02d", self.class.all.index(self) + 1)
  end

  def photo
    GalleryPhoto.find_by!(file: super)
  end
end
