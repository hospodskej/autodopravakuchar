class PagesController < ApplicationController
  def home
    @photos = GalleryPhoto.all.values_at(1, 16, 18, 21)
  end

  def sluzby
  end

  def technika
    @photos = GalleryPhoto.all
  end

  def cenik
    @price_groups = PriceItem.ordered.group_by(&:category)
  end

  def kontakty
  end
end
