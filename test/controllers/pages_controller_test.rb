require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "every page in config/site.yml renders with its title and the shared layout" do
    SitePage.all.each do |page|
      get page.url
      assert_response :success, page.key
      assert_select "title", /#{Regexp.escape(page.title)}/
      assert_select ".site-nav a", SitePage.navigation.size
      assert_select ".site-footer .legal-info", /IČO #{Company.current.ico}/
    end
  end

  test "navigation marks the current page" do
    get cenik_url
    assert_select ".site-nav a.is-active[aria-current=page]", "Ceník"
  end

  test "home page" do
    get home_url
    assert_select ".hero h1", /Dovezeme/
    assert_select ".service-card", Service.all.size
    assert_select ".photo-grid--strip img", GalleryPhoto.featured.size
  end

  test "price list shows a contact prompt when empty" do
    get cenik_url
    assert_select ".empty-state h2", "Ceník připravujeme"
    assert_select "table.price-table", false
  end

  test "price list groups items by category" do
    PriceItem.create!(category: "Dovoz", name: "Písek", unit: "t", price: 450, position: 1)
    PriceItem.create!(category: "Práce", name: "Práce bagrem", position: 1)

    get cenik_url
    assert_select ".price-group h2", 2
    assert_select "td.price", "450 Kč / t"
    assert_select "td.price", "dle dohody"
  end

  test "contacts page" do
    get kontakty_url
    assert_select "a.contact-card[href='#{Company.current.phone_uri}']"
    assert_select "a.contact-card[href='#{Company.current.email_uri}']"
  end

  test "services page" do
    get sluzby_url
    assert_select ".service-row", Service.all.size
  end

  test "equipment gallery is grouped by vehicle and opens photos in the lightbox" do
    get technika_url
    GalleryCategory.all.each do |category|
      assert_select "section##{category.key} h2", category.title
      assert_select "section##{category.key} a[data-lightbox] img", category.photos.size
    end
    assert_select "dialog#lightbox button[data-action=close]"
    assert_select "script[src*=lightbox]"
  end
end
