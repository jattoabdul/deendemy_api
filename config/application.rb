require_relative 'boot'
require_relative '../app/middleware/rescue_json_parse_errors'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DeendemyApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.active_job.queue_adapter = :sidekiq

    config.middleware.use Rack::Attack

    config.middleware.use RescueJsonParseErrors

    # Cors Setup
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        # resource '/assets/*', headers: :any, methods: [:options, :head]
        resource '*',
        headers: :any,
        # expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
        methods: [:get, :post, :options, :put, :patch]
      end
    end
  
    config.api_only = true
  end
end
