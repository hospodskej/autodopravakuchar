Rails.application.routes.draw do
  # One route per page in config/site.yml, e.g. GET /cenik -> pages#cenik (cenik_path).
  SitePage.all.each do |page|
    get page.url, to: "pages##{page.key}", as: page.key
  end

  post SitePage.find_by!(key: "poptavka").url, to: "inquiries#create", as: :inquiries

  get "sitemap.xml", to: "seo#sitemap", defaults: { format: :xml }, as: :sitemap
  get "robots.txt", to: "seo#robots", defaults: { format: :text }, as: :robots

  # Error pages, rendered through config.exceptions_app.
  match "/:status", to: "errors#show", via: :all, constraints: { status: /\d{3}/ }

  get "up" => "rails/health#show", as: :rails_health_check
end
