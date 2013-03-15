class Review < ActiveRecord::Base
  attr_accessible :user_id, :location_id, :message

  belongs_to :user
  belongs_to :location
end