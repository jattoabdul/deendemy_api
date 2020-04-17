Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  # if Rails.root.join('tmp', 'caching-dev.txt').exist?
  config.action_controller.perform_caching = true
  config.cache_store = :redis_store, ENV['REDIS_URL']
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
  }
  # else
  #   config.action_controller.perform_caching = false
  #   config.cache_store = :null_store
  # end

  config.action_controller.default_url_options = { host: ENV.fetch('APPLICATION_HOST') }

  # Mount Action Cable outside main process or domain.
  config.action_cable.mount_path = '/cable/:uid'
  # config.action_cable.allowed_request_origins = ['*']

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Send emails to test server
  config.action_mailer.default_url_options = { host: ENV.fetch('APPLICATION_HOST', 'deendemy_mailcatcher') }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: 'deendemy_mailcatcher', # || 0.0.0.0
    port: 1025,
    openssl_verify_mode: 'none'
  }
  config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Bullet development setup
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    # Bullet.growl         = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Incase of slow loading due to mongo eagerloading all models
  # config.mongoid.preload_models = false

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

Rails.application.routes.default_url_options[:host] = ENV.fetch('APPLICATION_HOST')
