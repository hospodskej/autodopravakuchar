module ApplicationHelper
  def company
    Company.current
  end

  def nav_links(pages)
    safe_join(pages.map do |page|
      active = current_page?(page.url)
      link_to page.label, page.url, class: [ "nav-link", ("is-active" if active) ], aria: { current: ("page" if active) }
    end)
  end

  def page_url(key)
    SitePage.find_by!(key: key.to_s).url
  end

  def phone_link(label = company.phone, **options)
    link_to label, company.phone_uri, **options
  end

  def email_link(label = company.email, **options)
    link_to label, company.email_uri, **options
  end

  def address_link(**options, &block)
    link_to company.map_url, target: "_blank", rel: "noopener", **options, &block
  end

  # `responsive: true` lets the browser pick the 800px thumbnail or the 1600px original by screen width.
  def photo_tag(photo, full: false, responsive: false, **options)
    options[:srcset] = { photo.thumbnail_path => "800w", photo.path => "1600w" } if responsive
    image_tag (full || responsive ? photo.path : photo.thumbnail_path), alt: photo.alt, loading: "lazy", decoding: "async", **options
  end

  def format_price(item)
    return "dle dohody" if item.priced_individually?

    # Non-breaking spaces keep "1 250 Kč" together; the line may only wrap before the unit.
    amount = number_to_currency(item.price, unit: "Kč", format: "%n\u00a0%u", delimiter: "\u00a0", separator: ",",
                                            precision: item.price.frac.zero? ? 0 : 2)
    item.unit.present? ? "#{amount} / #{item.unit}" : amount
  end
end
