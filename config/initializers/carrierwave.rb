CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  }

  case Rails.env
    when 'production'
      config.fog_directory = ENV['AWS_BUCKET']
      # config.asset_host = 'https://s3-us-east-1.amazonaws.com/dummy'
    when 'development'
      config.fog_directory = ENV['AWS_BUCKET']
      # config.asset_host = 'https://s3-us-east-1.amazonaws.com/dev.dummy'
      # config.enable_processing = Rails.env.development?
    when 'test'
      config.fog_directory = ENV['AWS_BUCKET']
      # config.asset_host = 'https://s3-us-east-1.amazonaws.com/test.dummy'
  end
end
