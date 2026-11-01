class InquiriesController < ApplicationController
  rate_limit to: 5, within: 10.minutes, only: :create,
             with: -> { redirect_to page_path, alert: "Odeslali jste příliš mnoho poptávek. Zkuste to prosím za chvíli, nebo nám zavolejte." }

  def create
    @page = SitePage.find_by!(key: "poptavka")
    @inquiry = Inquiry.new(inquiry_params)

    # Bots get the same answer as people, so they learn nothing; nothing is sent.
    return redirect_to(page_path, notice: success_message) if @inquiry.spam?
    return render("pages/poptavka", status: :unprocessable_entity) unless @inquiry.valid?

    InquiryMailer.new_inquiry(@inquiry).deliver_now
    redirect_to page_path, notice: success_message
  rescue Net::SMTPError, IOError, SystemCallError, Timeout::Error => error
    Rails.logger.error("Inquiry e-mail failed: #{error.class}: #{error.message}")
    flash.now[:alert] = "Poptávku se nepodařilo odeslat. Zkuste to prosím znovu, nebo nám zavolejte na #{Company.current.phone}."
    render "pages/poptavka", status: :service_unavailable
  end

  private
    def inquiry_params
      params.expect(inquiry: [ :name, :phone, :email, :service, :place, :date, :message, :website, :started_at ])
    end

    def page_path
      SitePage.find_by!(key: "poptavka").url
    end

    def success_message
      "Děkujeme, poptávka byla odeslána. Ozveme se vám co nejdříve."
    end
end
