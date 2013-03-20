class ReviewsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :create]
  before_filter :load_location, only: [:index, :new, :create,:edit]

  def index
    @reviews = @location.reviews
  end

  def new
    @review = @location.reviews.new
  end

  def edit
    @review = @location.reviews.find(params[:id])
  end  

  def update
    @review = Review.find(params[:id])
    if @review.update_attributes(params[:review])
      redirect_to location_reviews_path
    else
      render "edit"  
    end  
  end  

  def create
    @review = @location.reviews.new(params[:review])
    @review.user = current_user
    if @review.save
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
end
