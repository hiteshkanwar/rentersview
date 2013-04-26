class LocationPhoto < ActiveRecord::Base
  attr_protected :id
  attr_accessible :imageable_id,:imageable_type,:location_id, :photo
  belongs_to :imageable, :polymorphic => true
  belongs_to :location
  
  has_attached_file :photo, 
                    :styles => {
                      :large => "800x748>",
                      :medium => "300x248>",
                      :thumb => "90x78>"
                    },
                    :storage => :s3,
                    :s3_credentials => {
                      :bucket => 'rentersviewnew',
                      :access_key_id => "AKIAJQQNROVXNSD4CVVQ",
                      :secret_access_key => "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"
                    }
                    #:path => "/:style/:id/:filename"

  validates_attachment_presence :photo
  validates_attachment_size :photo, :less_than => 5.megabytes

  include Rails.application.routes.url_helpers

end
