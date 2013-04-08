class Ad < ActiveRecord::Base
  attr_accessible :message, :user_id, :location_id, :contact, :suburb, :address,:location_photos

  validates :contact, :presence => true

  belongs_to :location
  belongs_to :user
  has_many :location_photos, :as => :imageable
end
