module ApplicationHelper
  def nav_link(label, path)
    active = current_page?(path) || (path == cenik_path && current_page?(root_path))
    link_to label, path, class: [ "button", ("is-active" if active) ], aria: { current: ("page" if active) }
  end

  def page_heading(text)
    content_for :title, text
    safe_join([ tag.h2(text, class: "page-title"), tag.hr ])
  end

  def format_price(item)
    return "dle dohody" if item.priced_individually?

    amount = number_to_currency(item.price, unit: "Kč", format: "%n %u", delimiter: " ", separator: ",",
                                            precision: item.price.frac.zero? ? 0 : 2)
    item.unit.present? ? "#{amount} / #{item.unit}" : amount
  end
end
