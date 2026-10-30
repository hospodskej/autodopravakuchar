require "test_helper"

class SecurityTest < ActionDispatch::IntegrationTest
  test "pages send security headers" do
    get "/"
    csp = response.headers["Content-Security-Policy"]
    assert_includes csp, "default-src 'self'"
    assert_includes csp, "frame-src https://www.openstreetmap.org"
    assert_includes csp, "frame-ancestors 'none'"
    assert_includes csp, "object-src 'none'"
    assert_includes response.headers["Permissions-Policy"], "camera=()"
    assert_equal "DENY", response.headers["X-Frame-Options"]
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
    assert_equal "strict-origin-when-cross-origin", response.headers["Referrer-Policy"]
    assert_equal "same-origin", response.headers["Cross-Origin-Opener-Policy"]
  end

  test "old browsers are not blocked" do
    get "/", headers: { "User-Agent" => "Mozilla/5.0 (iPhone; CPU iPhone OS 15_8 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.6 Mobile/15E148 Safari/604.1" }
    assert_response :success
  end

  test "favicon and Czech static error pages exist" do
    assert Rails.public_path.join("favicon.ico").file?
    %w[400 422 500].each do |status|
      html = Rails.public_path.join("#{status}.html").read
      assert_includes html, '<html lang="cs">'
      assert_includes html, "Autodoprava Kuchař"
    end
  end

  test "mobile header has a call button" do
    get "/"
    assert_select "a.site-header__call[href='#{Company.current.phone_uri}'][aria-label]"
  end
end
