Raven.configure do |config|
  config.dsn = ENV.fetch('SENTRY_DSN', nil)
  config.environments = %w[production staging]
  config.processors -= [Raven::Processor::PostData] # Enable post data
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
end
