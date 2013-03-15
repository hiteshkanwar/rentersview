require 'wikipedia'

class Location < ActiveRecord::Base
  attr_protected :id

  has_many :reviews, dependent: :destroy
  has_many :ads, dependent: :destroy
  has_many :location_photos, dependent: :destroy

  accepts_nested_attributes_for :reviews, :ads, :location_photos

  validates_presence_of :address1, :city, :region, :country
  
  #Wikipedia.Configure {
  #  domain 'en.wikipedia.org'
  #  path   'w/api.php'
  #}

  searchable do
    text :address1, :address2, :city, :region, :country, :postal_code
  end

  def full_address
    [address1, address2, city, region, country].select {|x| x.present?}.join(', ')
  end
end
