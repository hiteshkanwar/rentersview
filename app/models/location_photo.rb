class LocationPhoto < ActiveRecord::Base
  attr_protected :id
  
  belongs_to :location
  
  has_attached_file :photo, 
                    :styles => {:large => "800x748>", :medium => "300x248>", :thumb => "90x78>"},
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :bucket => "assets"
                    
  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes
end
