# initializers/s3.rb
if Rails.env == "production"
  # set credentials from ENV hash
  S3_CREDENTIALS = { :access_key_id => "AKIAJQQNROVXNSD4CVVQ", :secret_access_key => "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", :bucket => "rentersviewnew"}
else
  # get credentials from YML file
  S3_CREDENTIALS = Rails.root.join("config/s3.yml")
end
