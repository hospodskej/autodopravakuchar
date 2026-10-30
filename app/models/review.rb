class Review < Data.define(:author, :date, :text)
  extend SiteContent.collection(:reviews)
end
