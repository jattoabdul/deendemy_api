ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!
require 'devise'
require 'mongoid-rspec'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Remove this line to enable support for ActiveRecord
  config.use_active_record = false

  # config.fixture_path = "#{::Rails.root}/spec/fixtures"
  # config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include Mongoid::Matchers, type: :model

  config.include Rails.application.routes.url_helpers

  Warden.test_mode!

  config.after do
    Warden.test_reset!
  end

  config.include Helpers

  config.include Devise::Test::ControllerHelpers, type: :controller
  # config.include Requests::AuthHelpers::Includables, type: :controller
  # config.extend Requests::AuthHelpers::Extensions, type: :controller

  config.include Devise::Test::ControllerHelpers, type: :view

  # config.include Devise::Test::ControllerHelpers, type: :request
  config.include Requests::AuthHelpers::Includables, type: :request
  config.extend Requests::AuthHelpers::Extensions, type: :request

  # Configuration for Shoulda Gem. Used to complement tests.
  Shoulda::Matchers.configure do |sconfig|
    sconfig.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

  config.before(:suite) do
    # prep factory_run tracking
    FactoryBot::Analytics.track_factories

    # Rails seed?
    Rails.application.load_seed

    # Clear cache
    Rails.cache.clear
  end

  config.after(:suite) do
    # Clear cache
    Rails.cache.clear

    FactoryBot::Analytics.print_statistics
  end

  # Bullet setup for test environment
  if Bullet.enable?
    config.before(:each) { Bullet.start_request }
    config.after(:each) do
      Bullet.perform_out_of_channel_notifications if Bullet.notification?
      Bullet.end_request
    end
  end
end

module ReportableExceptionHelper
  def method_added(method)
    return unless @rxp_methods.include?(method)
    return if @rxp_defined_methods.include?(method)

    @rxp_defined_methods << method
    orig_method = instance_method(method)
    define_method(method) do |*args, &block|
      orig_method.bind(self).call(*args, &block)
    # rescue *@rxp_error, StandardError => e
    rescue *@rxp_error => e
      Raven.capture_exception(e)
      raise self.class::Error, e.message
    end
  end

  def reportable_exception(*method_names, error: StandardError)
    @rxp_defined_methods = []
    @rxp_methods = method_names
    @rxp_error = error
  end
end
