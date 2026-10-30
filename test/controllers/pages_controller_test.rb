require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "root renders the price list" do
    get root_url
    assert_response :success
    assert_select "h2.page-title", "Ceník"
  end

  test "price list shows a contact prompt when empty" do
    get cenik_url
    assert_response :success
    assert_select ".empty-state", /Ceník připravujeme/
    assert_select "table.price-table", false
  end

  test "price list groups items by category" do
    PriceItem.create!(category: "Dovoz", name: "Písek", unit: "t", price: 450, position: 1)
    PriceItem.create!(category: "Práce", name: "Práce bagrem", position: 1)

    get cenik_url
    assert_response :success
    assert_select ".price-group h3", 2
    assert_select "td.price", "450 Kč / t"
    assert_select "td.price", "dle dohody"
  end

  test "navigation links to all pages" do
    get cenik_url
    assert_select "nav.site-nav a", 4
    assert_select "nav.site-nav a.is-active[aria-current=page]", "Ceník"
  end

  test "contacts page" do
    get kontakty_url
    assert_response :success
    assert_select "a[href='tel:+420739291053']"
    assert_select "a[href='mailto:info@adkuchar.cz']"
  end

  test "services page" do
    get sluzby_url
    assert_response :success
    assert_select ".services h3", 4
  end

  test "equipment gallery" do
    get technika_url
    assert_response :success
    assert_select ".gallery img", PagesController::GALLERY_IMAGES.size
  end
end
