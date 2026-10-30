class Company < Data.define(:name, :owner, :ico, :register, :tagline, :description, :phone, :email,
                            :street, :postal_code, :city, :district, :region)
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

  def map_embed_url
    "https://maps.google.com/maps?q=#{map_query}&z=14&hl=cs&output=embed"
  end

  private
    def map_query
      ERB::Util.url_encode(address_lines.join(", "))
    end
end
