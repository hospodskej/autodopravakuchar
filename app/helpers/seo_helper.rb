module SeoHelper
  def canonical_url(page)
    company.website + page.url.delete_suffix("/")
  end

  def preview_image_url
    company.website + image_path("og-image.jpg")
  end

  # schema.org data that Google uses for the business panel and rich results.
  def business_structured_data
    {
      "@context": "https://schema.org",
      "@type": "LocalBusiness",
      "@id": "#{company.website}/#firma",
      name: company.name,
      url: company.website,
      image: preview_image_url,
      logo: "#{company.website}/icon.png",
      description: company.description,
      telephone: company.phone,
      email: company.email,
      founder: { "@type": "Person", name: company.owner },
      identifier: { "@type": "PropertyValue", propertyID: "IČO", value: company.ico },
      address: {
        "@type": "PostalAddress",
        streetAddress: company.street,
        postalCode: company.postal_code,
        addressLocality: company.city,
        addressCountry: "CZ"
      },
      geo: { "@type": "GeoCoordinates", latitude: company.latitude, longitude: company.longitude },
      areaServed: { "@type": "AdministrativeArea", name: company.region },
      openingHoursSpecification: company.nonstop ? nonstop_opening_hours : nil,
      sameAs: [ company.facebook ],
      hasOfferCatalog: {
        "@type": "OfferCatalog",
        name: "Služby",
        itemListElement: Service.all.map do |service|
          { "@type": "Offer", itemOffered: { "@type": "Service", name: service.title, description: service.summary } }
        end
      }
    }.compact
  end

  def structured_data_tag(data)
    tag.script(data.to_json.html_safe, type: "application/ld+json")
  end

  private
    def nonstop_opening_hours
      { "@type": "OpeningHoursSpecification", dayOfWeek: Date::DAYNAMES, opens: "00:00", closes: "23:59" }
    end
end
