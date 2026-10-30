# Security headers. Everything is served from our own domain except the OpenStreetMap iframe in the footer.
# The JSON-LD <script type="application/ld+json"> is data, not code, so it needs no script-src exception.
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.script_src :self
    policy.style_src :self
    policy.img_src :self, :data
    policy.font_src :self
    policy.connect_src :self
    policy.frame_src "https://www.openstreetmap.org"
    policy.object_src :none
    policy.base_uri :self
    policy.form_action :self
    policy.frame_ancestors :none
    policy.upgrade_insecure_requests true if Rails.env.production?
  end

  # Rails' permissions_policy still emits the obsolete Feature-Policy header, so set the modern one directly.
  config.action_dispatch.default_headers.merge!(
    "Permissions-Policy" => "camera=(), microphone=(), geolocation=(), payment=(), usb=(), gyroscope=(), accelerometer=(), fullscreen=(self)",
    "X-Frame-Options" => "DENY",
    "Cross-Origin-Opener-Policy" => "same-origin"
  )
end
