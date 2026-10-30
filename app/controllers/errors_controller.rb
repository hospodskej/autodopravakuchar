# Rendered by config.exceptions_app. 404 gets the site layout; other errors fall back to the static pages in public/.
class ErrorsController < ApplicationController
  skip_forgery_protection
  def show
    status = params[:status].to_i

    if status == 404
      @page = SitePage.not_found
      render :not_found, status: :not_found
    else
      # The static pages carry their own inline styles, so they are served without the CSP header.
      request.content_security_policy = nil
      file = Rails.public_path.join("#{status}.html")
      render file: file.exist? ? file : Rails.public_path.join("500.html"), layout: false, status: status
    end
  end
end
