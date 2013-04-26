# initializers/s3.rb
if Rails.env == "production"
  # set credentials from ENV hash
   S3_CREDENTIALS = Rails.root.join("config/s3.yml")
else
  # get credentials from YML file
  S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end
