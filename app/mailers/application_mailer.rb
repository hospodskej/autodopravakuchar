class ApplicationMailer < ActionMailer::Base
  default from: -> { "Web #{Company.current.name} <#{Company.current.email}>" }
  layout false
end
