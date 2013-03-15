class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :latest_locations, :get_some_ads
  
  def latest_locations
    @latest_locations = Location.last(3)
    @latest_locations2 = Location.last(6)
    
    @latests_locations3 = Location.last(2)
    @popular_locations2 = Location.select("locations.*, count(reviews.id) as review_counts").joins(:reviews).group("locations.id").order("review_counts DESC").limit(2)
  end
  
  def get_some_ads
    @some_ads = Ad.last(7)
  end
end
