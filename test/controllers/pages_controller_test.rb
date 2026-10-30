require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page" do
    get root_url
    assert_response :success
    assert_select ".hero h1", /Dovezeme/
    assert_select ".service-card", 4
    assert_select ".photo-strip img", 4
    assert_select "a[href='#{Company::PHONE_URI}']"
  end

  test "navigation links to all pages and marks the current one" do
    get cenik_url
    assert_select ".site-nav a", 4
    assert_select ".site-nav a.is-active[aria-current=page]", "Ceník"
  end

  test "price list shows a contact prompt when empty" do
    get cenik_url
    assert_response :success
    assert_select ".empty-state h2", "Ceník připravujeme"
    assert_select "table.price-table", false
  end

  test "price list groups items by category" do
    PriceItem.create!(category: "Dovoz", name: "Písek", unit: "t", price: 450, position: 1)
    PriceItem.create!(category: "Práce", name: "Práce bagrem", position: 1)

    get cenik_url
    assert_response :success
    assert_select ".price-group h2", 2
    assert_select "td.price", "450 Kč / t"
    assert_select "td.price", "dle dohody"
  end

  test "contacts page" do
    get kontakty_url
    assert_response :success
    assert_select "a.contact-card[href='tel:+420739291053']"
    assert_select "a.contact-card[href='mailto:info@adkuchar.cz']"
  end

  test "services page" do
    get sluzby_url
    assert_response :success
    assert_select ".service-row", 4
  end

  test "equipment gallery serves local photos" do
    get technika_url
    assert_response :success
    assert_select ".gallery img", GalleryPhoto.all.size
    assert_select ".gallery img[src*='adkuchar.cz']", false
  end
end
