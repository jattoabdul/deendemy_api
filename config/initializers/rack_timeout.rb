# frozen_string_literal: true

# Set Service timeout
# https://github.com/heroku/rack-timeout#service-timeout
Rails.application.config.middleware.insert_before Rack::Runtime, Rack::Timeout, service_timeout: 15 # seconds

# Disable logger
Rack::Timeout::Logger.disable
