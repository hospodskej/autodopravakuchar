Rails.application.routes.draw do
  # One route per page in config/site.yml, e.g. GET /cenik -> pages#cenik (cenik_path).
  SitePage.all.each do |page|
    get page.url, to: "pages##{page.key}", as: page.key
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
