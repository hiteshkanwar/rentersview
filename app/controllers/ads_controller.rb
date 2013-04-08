class AdsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :load_location, only: [:index, :new, :create,:edit,:update]
  before_filter :remove_params,only: [:create,:update]
  def index
    @ads = @location.ads
  end

  def new
    @ad = @location.ads.build
  end

  def edit
   @ad =  @location.ads.find(params[:id])
  end

  def create
    @ad = @location.ads.new(params[:ad])
    @ad.user = current_user
    if @ad.save
      if !params['location_photos'].blank?
          params['location_photos'].each do |photo|
            LocationPhoto.create(:location_id => @location.id, :photo => photo,:imageable_id=>@ad.id,:imageable_type=>'Ad')
          end
      end
      UserMailer.welcome_user(@ad.user,@ad).deliver
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

  def update
  
    @ad = Ad.find(params[:id])
    # if !@ad.location_photos.blank?
    #   @ad.location_photos.each do |p|
    #     p.destroy
    #   end
    # end
    if !params['location_photos'].blank?
        params['location_photos'].each do |photo|
          @ad.location_photos.create(:location_id => params[:location_id], :photo => photo,:imageable_id=>@ad.id,:imageable_type=>'Ad')
        end
    end
    if @ad.update_attributes(params[:ad])
      redirect_to  location_reviews_path(@location)
    else
      render "edit"
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

  def remove_params
    if params[:ad][:location_photos].present?
     params[:ad].delete :location_photos
     return params[:ad]
    end
  end

end
