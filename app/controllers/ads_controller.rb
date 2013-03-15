class AdsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :load_location, only: [:index, :new, :create]

  def index
    @ads = @location.ads
  end

  def new
    @ad = @location.ads.new
  end

  def create
    @ad = @location.ads.new(params[:ad])
    @ad.user = current_user
    if @ad.save
      redirect_to location_reviews_path(@location), notice: 'Ad added successfully.'
    else
      render :new
    end
  end
  
  def createAd
    if user = User.where("uid = ?", params[:facebookId]).first
      if !params[:facebookId]
        response = "Error - The Facebook ID is required."
      else
        Ad.create(:location_id => params[:locationId], :contact => params[:address], 
                  :message => params[:content], :user_id => user.id)
      end
    end
  end
  
  def getAdsByLocation
    reviews = Ad.where(:location_id => params[:locationId])
    
    render :json => reviews
  end

  private

  def load_location
    @location = Location.find(params[:location_id])
  end

end
