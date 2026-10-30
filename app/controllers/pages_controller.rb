# Each page in config/site.yml renders app/views/pages/<key>.html.erb; actions exist only where a page needs data.
class PagesController < ApplicationController
  before_action { @page = SitePage.find_by!(key: action_name) }

  def cenik
    @price_groups = PriceItem.ordered.group_by(&:category)
  end
end
