class Ad < ActiveRecord::Base
  attr_accessible :message, :user_id, :location_id, :contact, :suburb, :address

  validates :contact, :presence => true

  belongs_to :location
  belongs_to :user

end
