
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id      => Rails.application.secrets.S3_ACCESS_KEY,                        # required
      :aws_secret_access_key  => Rails.application.secrets.S3_SECRET_KEY, 
    }
    config.fog_directory     =  ENV['sampleproject']
  end
end

