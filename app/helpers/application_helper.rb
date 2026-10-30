module ApplicationHelper
  NAV_ITEMS = [
    [ "Služby", :sluzby_path ],
    [ "Technika", :technika_path ],
    [ "Ceník", :cenik_path ],
    [ "Kontakty", :kontakty_path ]
  ].freeze

  def nav_links
    safe_join(NAV_ITEMS.map do |label, route|
      path = public_send(route)
      active = current_page?(path)
      link_to label, path, class: [ "nav-link", ("is-active" if active) ], aria: { current: ("page" if active) }
    end)
  end

  def phone_link(label = Company::PHONE, **options)
    link_to label, Company::PHONE_URI, **options
  end

  def page_header(title, lead = nil)
    content_for :title, title
    tag.header(class: "page-header") do
      tag.div(class: "container") do
        safe_join([ tag.p("Autodoprava Kuchař", class: "eyebrow"), tag.h1(title), (tag.p(lead, class: "lead") if lead) ].compact)
      end
    end
  end

  def gallery_thumbnail(photo, **options)
    image_tag photo.thumbnail_path, alt: photo.alt, loading: "lazy", decoding: "async", **options
  end

  def format_price(item)
    return "dle dohody" if item.priced_individually?

    amount = number_to_currency(item.price, unit: "Kč", format: "%n %u", delimiter: " ", separator: ",",
                                            precision: item.price.frac.zero? ? 0 : 2)
    item.unit.present? ? "#{amount} / #{item.unit}" : amount
  end
end
