# Based on production defaults
require Rails.root.join("config/environments/production")

Rails.application.routes.default_url_options[:host] = ENV.fetch('APPLICATION_HOST')
