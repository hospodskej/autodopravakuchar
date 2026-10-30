require "test_helper"

class SeoTest < ActionDispatch::IntegrationTest
  include SeoHelper
  include ApplicationHelper

  test "every page has its own title, description, canonical URL and preview image" do
    SitePage.all.each do |page|
      get page.url
      assert_select "title", page.document_title
      assert_select "meta[name=description][content=?]", page.description
      assert_select "link[rel=canonical][href=?]", canonical_url(page)
      assert_select "meta[property='og:image'][content$='.jpg']"
    end
  end

  test "business details are published as schema.org LocalBusiness" do
    get home_url
    data = JSON.parse(css_select("script[type='application/ld+json']").first.text)
    company = Company.current

    assert_equal "LocalBusiness", data["@type"]
    assert_equal company.phone, data["telephone"]
    assert_equal company.ico, data.dig("identifier", "value")
    assert_equal company.street, data.dig("address", "streetAddress")
    assert_equal [ company.facebook ], data["sameAs"]
    assert_equal 7, data.dig("openingHoursSpecification", "dayOfWeek").size
    assert_equal Service.all.size, data.dig("hasOfferCatalog", "itemListElement").size
  end

  test "sitemap lists every page" do
    get sitemap_url
    assert_response :success
    assert_equal "application/xml", response.media_type
    locs = Nokogiri::XML(response.body).remove_namespaces!.xpath("//loc").map(&:text)
    assert_equal SitePage.all.map { |page| canonical_url(page) }, locs
  end

  test "robots.txt points to the sitemap" do
    get robots_url
    assert_response :success
    assert_includes response.body, "Sitemap: #{Company.current.website}/sitemap.xml"
  end

  test "unknown URLs get the custom 404 page" do
    without_detailed_exceptions { get "/eshop" }
    assert_response :not_found
    assert_select "h1", "Stránka nenalezena"
    assert_select "meta[name=robots][content=noindex]"
    assert_select ".not-found a[href='#{Company.current.phone_uri}']"
  end

  private
    # The test environment shows Rails' debug page for errors; production shows the real error pages.
    def without_detailed_exceptions
      env_config = Rails.application.env_config
      original = env_config["action_dispatch.show_detailed_exceptions"]
      env_config["action_dispatch.show_detailed_exceptions"] = false
      yield
    ensure
      env_config["action_dispatch.show_detailed_exceptions"] = original
    end
end
