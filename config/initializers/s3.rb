# initializers/s3.rb
if Rails.env == "production"
  # set credentials from ENV hash
  S3_CREDENTIALS = { :access_key_id => ENV['S3_KEY'], :secret_access_key => ENV['S3_SECRET'], :bucket => "rentersview"}
else
  # get credentials from YML file
  S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end

# in your model
has_attached_file :photo, :storage => :s3, :s3_credentials => S3_CREDENTIALS
