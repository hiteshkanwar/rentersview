class Review < ActiveRecord::Base
  attr_accessible :user_id, :location_id, :message,:location_photos

  belongs_to :user
  belongs_to :location
  has_many :location_photos, :as => :imageable
end