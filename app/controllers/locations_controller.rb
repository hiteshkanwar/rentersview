class LocationsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]

  def show
    @location = Location.find(params[:id])
  end

  def new
    @location = Location.new(geocode_new_address(params[:address]))
    if params[:type] == 'ad'
      @ad = @location.ads.new
    else
      @review = @location.reviews.new
    end
  end

  def create
    add_user_info_to_nested_attribute(params)
    
    @location = Location.new(params[:location])
    
    if @location.save
      if !params['location_photos'].blank?
        params['location_photos'].each do |photo|
          LocationPhoto.create(:location_id => @location.id, :photo => photo)
        end
      end
    
      redirect_to location_reviews_path(@location), notice: 'Location added successfully.'
    else
      if params[:location][:ads_attributes]
        @ad = @location.ads.new
      else
        @review = @location.reviews.new
      end
      render :new
    end
  end
  
  def getAllLocations
    locations = Location.all
    
    render :json => locations
  end
  
  def getLastLocations
    locations = Location.all.limit(10)
    
    render :json => locations
  end

  private

  def geocode_new_address(address)
    if address.present?
      if result = Geocoder.search(address)[0]
        {
          country: result.country,
          postal_code: result.postal_code,
          region: result.state_code,
          city: result.city,
          address1: "#{geocode_find_by_type(result, 'street_number')} #{geocode_find_by_type(result, 'route')}",
          latitude: result.latitude,
          longitude: result.longitude
        }
      end
    end
  end

  def geocode_find_by_type(result, type)
    info_hash = result.address_components.find {|x| x['types'].include?(type)}
    info_hash.present? ? info_hash['long_name'] : nil
  end

  def add_user_info_to_nested_attribute(params)
    (params[:location][:ads_attributes] || params[:location][:reviews_attributes])['0'].merge!({user_id: current_user.id})
  end

end
