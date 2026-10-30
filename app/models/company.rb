class Company < Data.define(:name, :owner, :ico, :register, :tagline, :description, :phone, :email,
                            :street, :postal_code, :city, :district, :region, :latitude, :longitude, :facebook, :facebook_reviews)
  def self.current
    @current ||= SiteContent.build(self, SiteContent.fetch(:company))
  end

  def phone_uri
    "tel:#{phone.delete(" ")}"
  end

  def email_uri
    "mailto:#{email}"
  end

  def address_lines
    [ street, "#{postal_code} #{city}" ]
  end

  def initials
    name.split.map(&:first).join
  end

  def map_url
    "https://www.google.com/maps/search/?api=1&query=#{map_query}"
  end

  # OpenStreetMap embed: loads without cookies, so no consent banner is needed.
  def map_embed_url(span: 0.006)
    bbox = [ longitude - span * 2, latitude - span, longitude + span * 2, latitude + span ].join(",")
    "https://www.openstreetmap.org/export/embed.html?bbox=#{bbox}&layer=mapnik&marker=#{latitude},#{longitude}"
  end

  private
    def map_query
      ERB::Util.url_encode(address_lines.join(", "))
    end
end
