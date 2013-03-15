class SearchController < ApplicationController

  def index
    @results = Location.search do
      fulltext params[:query]
    end.results
    
    @wiki = Wikipedia.find(params[:query])
  end
  
  def searchLocations
    locations = Location.search do
      fulltext params[:query]
    end
    
    render :json => locations.results
  end
end
