CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV['AWS_REGION']
  }

  # config.fog_public     = false # optional, default to true, which means no expiry on urls
  config.fog_authenticated_url_expiration = 600

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
