
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAIRCJDMBQZAR674GQ'],
      :aws_secret_access_key => ENV['1hAWnWMvmYVoHyM/rfKR+cXCD6TkF2YYbV1sQaX6']
    }
    config.fog_directory     =  ENV['sampleproject']
  end
end

