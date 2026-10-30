require "test_helper"

class SiteContentTest < ActiveSupport::TestCase
  test "services reference existing photos" do
    Service.all.each { |service| assert_kind_of GalleryPhoto, service.photo }
  end

  test "home page is not in the header navigation" do
    assert_not_includes SitePage.navigation.map(&:key), "home"
  end

  test "company contact helpers" do
    company = Company.current
    assert_equal "tel:+420739291053", company.phone_uri
    assert_equal "19365969", company.ico
    assert_includes company.map_url, "T%C4%9B%C5%A1etice%2039"
  end
end
