class ReviewsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :load_location, only: [:index, :new, :create,:edit,:update]
  before_filter :remove_params,only: [:create]
  def index
    @reviews = @location.reviews
    if !current_user.nil?
      @my_reviews = current_user.reviews
    end
  end

  def new
    @review = @location.reviews.new
  end

  def edit
    @review = @location.reviews.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    #  @review.location_photos.each do |p|
    #   p.destroy
    # end
    if !params['location_photos'].blank?
        params['location_photos'].each do |photo|
          @review.location_photos.create(:location_id => params[:location_id], :photo => photo,:imageable_id=>@review.id,:imageable_type=>'Review')
        end
    end
    if @review.update_attributes(:message=>params[:review][:message])
        
      redirect_to location_reviews_path(@location)
    else
      render "edit"
    end
  end

  def create
    @review = @location.reviews.new(params[:review])
    @review.user = current_user
    if @review.save
      if !params['location_photos'].blank?
        params['location_photos'].each do |photo|
          LocationPhoto.create(:location_id => @location.id, :photo => photo,:imageable_id=>@review.id,:imageable_type=>'Review')
        end
      end
      redirect_to location_reviews_path(@location), notice: 'Review added successfully.'
    else
      render :new
    end
  end

  # mobile API
  def doReview
    if user = User.where("uid = ?", params[:facebookId]).first
      if !params[:facebookId]
        response = "Error - The Facebook ID is required."
      else
        search = Location.search do
          fulltext params[:address]
        end

        if search.results.size > 0
          response = search.results
        else
          location = Location.create(:address1 => params[:address],
                          :city => params[:city], :region => params[:region], :country => params[:country],
                          :postal_code => params[:postalCode], :longitude => params[:longitude],
                          :latitude => params[:latitude])

          if location
            review = Review.create(:user_id => user.id, :location_id => location.id, :message => params[:reviewMessage])
            if review
              response = review
            else
              responde = "Error - The review has not been saved."
            end
          else
            response = "Error - The location has not been saved."
          end
        end
      end
    else
      response = "Error - The Facebook ID does not exists in the system."
    end
    render :json => response
  end
  
  def getReviewsByLocation
    reviews = Review.where(:location_id => params[:locationId])
    
    render :json => reviews
  end
  
  def getLastReviews
    reviews = Review.limit(10)
    
    render :json => reviews
  end

  private

  def load_location
    @location = Location.find(params[:location_id])
    @latests_locations = Location.last(2)
    @popular_locations = Location.select("locations.*, count(reviews.id) as review_counts").joins(:reviews).group("locations.id").order("review_counts DESC").limit(2)
  end

  def remove_params
    if params[:review][:location_photos].present?
     params[:review].delete :location_photos
     return params[:review]
    end
  end
end
