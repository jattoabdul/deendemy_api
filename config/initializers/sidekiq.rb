require 'sidekiq'

redis_url = ENV.fetch('REDIS_URL') { 'redis://127.0.0.1:6379' }

Sidekiq.configure_client do |config|
  config.redis = {
    url: redis_url,
    driver: :hiredis
  }.merge(Rails.env.development? ? {} : { size: 2 })
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: redis_url,
    driver: :hiredis
  }.merge(Rails.env.development? ? {} : { size: 20 })

  config.server_middleware do |chain|
    chain.add Sidekiq::RetryMonitoring::Middleware
  end
end
