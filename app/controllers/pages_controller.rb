class PagesController < ApplicationController
  GALLERY_BASE_URL = "https://adkuchar.cz/wp-content/uploads/2025/02/".freeze
  GALLERY_IMAGES = %w[
    09.06.11-1024x768 09.06.14-1-1024x768 09.06.14-2-1024x768 09.06.14-3-1024x768
    09.06.14-768x1024 09.06.15-1-1024x768 09.06.15-2-1024x769 09.06.15-3-1024x769
    09.06.15-1024x768 09.06.16-1-1024x768 09.06.16-2 09.06.16-3-1024x769
    09.06.16-1024x769 09.06.17-1-1024x768 09.06.17-2-1024x768 09.06.17-3-1024x768
    09.06.17-4-1024x768 09.06.17-1024x768 09.06.18-1-1024x768 09.06.18-2-1024x768
    09.06.18-1024x768 09.06.19-1-1024x768 09.06.19-1024x768
  ].map { |suffix| "#{GALLERY_BASE_URL}WhatsApp-Image-2025-02-12-at-#{suffix}.jpeg" }.freeze

  def cenik
    @price_groups = PriceItem.ordered.group_by(&:category)
  end

  def kontakty
  end

  def sluzby
  end

  def technika
    @images = GALLERY_IMAGES
  end
end
