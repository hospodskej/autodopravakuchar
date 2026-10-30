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

  def map_url
    "https://www.google.com/maps/search/?api=1&query=#{ERB::Util.url_encode(address_lines.join(", "))}"
  end
end
