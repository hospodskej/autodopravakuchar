class InquiryMailer < ApplicationMailer
  def new_inquiry(inquiry)
    @inquiry = inquiry
    mail to: Company.current.email,
         reply_to: inquiry.email.presence,
         subject: "Nová poptávka z webu: #{inquiry.service} – #{inquiry.name}"
  end
end
