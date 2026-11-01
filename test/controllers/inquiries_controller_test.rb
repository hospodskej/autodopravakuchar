require "test_helper"

class InquiriesControllerTest < ActionDispatch::IntegrationTest
  # Delivery method that behaves like an unreachable SMTP server.
  class UnreachableSmtp
    def initialize(_settings) = nil
    def deliver!(_mail) = raise(Errno::ECONNREFUSED)
  end
  ActionMailer::Base.add_delivery_method :unreachable_smtp, UnreachableSmtp

  def valid_params(**overrides)
    {
      name: "Jan Novák", phone: "+420 777 123 456", email: "jan@example.cz", service: "Dovoz",
      place: "Znojmo", date: "příští týden", message: "Potřebuji 5 t štěrku.", website: "",
      started_at: travel_to(1.minute.ago) { Inquiry.signed_start_time }
    }.merge(overrides)
  end

  test "form page renders with services and spam traps" do
    get poptavka_url
    assert_response :success
    assert_select "form[action='#{inquiries_path}'] select[name='inquiry[service]'] option", Inquiry.services.size + 1
    assert_select "input[name='inquiry[website]']"
    assert_select "input[type=hidden][name='inquiry[started_at]']"
  end

  test "service can be preselected from the URL" do
    get poptavka_url(sluzba: "Práce bagrem")
    assert_select "option[selected]", "Práce bagrem"
  end

  test "valid inquiry is e-mailed to the company" do
    assert_emails 1 do
      post inquiries_path, params: { inquiry: valid_params }
    end
    assert_redirected_to poptavka_path
    follow_redirect!
    assert_select ".flash--success", /poptávka byla odeslána/

    mail = ActionMailer::Base.deliveries.last
    assert_equal [ Company.current.email ], mail.to
    assert_equal [ "jan@example.cz" ], mail.reply_to
    assert_includes mail.subject, "Dovoz – Jan Novák"
    assert_includes mail.body.to_s, "Potřebuji 5 t štěrku."
  end

  test "invalid inquiry shows Czech errors and sends nothing" do
    assert_no_emails do
      post inquiries_path, params: { inquiry: valid_params(name: "", phone: "abc", service: "Nesmysl") }
    end
    assert_response :unprocessable_entity
    assert_select ".flash--error li", "Jméno musí být vyplněno"
    assert_select "#inquiry_phone[aria-invalid=true]"
    assert_select "#inquiry_phone_error", "nemá správný formát"
    assert_select "#inquiry_service_error", "musí být vybrána ze seznamu"
  end

  test "honeypot and too-fast submissions are silently dropped" do
    [ valid_params(website: "http://spam.example"), valid_params(started_at: Inquiry.signed_start_time),
      valid_params(started_at: "forged") ].each do |params|
      assert_no_emails { post inquiries_path, params: { inquiry: params } }
      assert_redirected_to poptavka_path
    end
  end

  test "mail failure shows an error with the phone number" do
    original = InquiryMailer.delivery_method
    begin
      InquiryMailer.delivery_method = :unreachable_smtp
      post inquiries_path, params: { inquiry: valid_params }
    ensure
      InquiryMailer.delivery_method = original
    end
    assert_response :service_unavailable
    assert_select ".flash--error", /nepodařilo odeslat.*#{Regexp.escape(Company.current.phone)}/
    assert_select "#inquiry_name[value='Jan Novák']"
  end
end
