class SeoController < ApplicationController
  def sitemap
    @pages = SitePage.all
  end

  def robots
  end
end
