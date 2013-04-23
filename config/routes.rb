RentersView::Application.routes.draw do
  get "pages/index"

  devise_for :users, :controllers => { :registrations => "users/registrations",
                                       :omniauth_callbacks => "users/omniauth_callbacks" }

  root :to => "home#index"

  resources :locations, only: [:new, :create, :show] do
    resources :reviews, only: [:index, :new, :create,:edit,:update,:destroy] do
    post :new_preview, :on => :collection
    get :delete_review,:on => :collection
  end
    resources :ads, only: [:index, :new, :create,:edit,:update]
  end

  resources :messages, only: [:index, :new, :create, :show]

  get '/search' => 'search#index'

  # Mobile API
  get "/api/doAccess" => "users#doAccess"
  get "/api/doReview" => "reviews#doReview"
  get "/api/createAd" => "ads#createAd" # facebookId, locationId, address, content
  get "/api/getAllLocations" => "locations#getAllLocations"
  get "/api/searchLocations" => "locations#searchLocations" # query
  get "/api/getReviewsByLocation" => "reviews#getReviewsByLocation" # locationId
  get "/api/getLastReviews" => "reviews#getLastReviews"
  get "/api/getAdsByLocation" => "reviews#getAdsByLocation" # locationId
  
  # Pages
  match "about-us" => "pages#about_us"
  match "terms-and-conditions" => "pages#terms_and_conditions"
  match "privacy" => "pages#privacy"
  match "help" => "pages#help"
  match "contact-us" => "pages#contact_us"
 # match "/locations/:location_id/reviews/new_preview"=>"reviews/new_preview"
  get "users/:id/reviews" => "users#reviews"
end
