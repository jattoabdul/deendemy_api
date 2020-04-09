source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# CORE
gem 'rails', '~> 6.0.2', '>= 6.0.2.2'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'puma', '~> 4.1' # Use Puma as the app server - 4.3

# RUBY HACKING
gem 'concurrent-ruby', '~> 1.1'
gem 'virtus', '~> 1.0'
gem 'tzinfo-data' # gem 'tzinfo-data', '~> 1.2019'
gem 'active_hash', '~> 2.3'

# DATA
gem 'mongoid', '~> 7.0.5'
gem 'bson_ext'
gem 'countries', '~> 3.0'
gem 'ice_nine', '~> 0.11'

# USER
# gem 'devise', '~> 4.7'
# gem 'bcrypt', '~> 3.1.7'
# gem 'phony_rails', '~> 0.14'
# gem 'StreetAddress', require: 'street_address'

# JSON, API SEC
gem 'oj', '~> 3.9'
# gem 'jbuilder', '~> 2.9'
gem 'jsonapi-rails', '~> 0.4'
gem 'jwt', '~> 2.2'

# STATEMACHINE
gem 'state_machines-mongoid'

# API REQUESTS
gem 'http', '~> 4.1'
gem 'rest-client', '~> 2.0'

# EXTERNAL SERVICES
# gem 'mandrill-api', '~> 1.0'
# gem 'stripe', '~> 3.3'
# gem 'twilio-ruby', '~> 5.6.4'
# gem 'aws-sdk-s3', '~> 1.0'
# gem 'taxjar-ruby', '~> 2.6', require: 'taxjar'
# gem 'slack-ruby-client', '~> 0.14'
# gem 'gibbon', '~> 3.2'
# gem 'shortener', '~> 0.8'
# gem 'mixpanel-ruby', '~> 2.2'
# gem 'searchkick', '~> 4.1' # Elastic search
# gem 'searchjoy', '~> 0.4' # Elastic search
# gem 'newrelic_rpm'

# PRODUCTION/STAGING
group :production, :staging do
  gem 'lograge', '~> 0.11'
end

# JOB SERVER
gem 'redis', '~> 4.1'
gem 'hiredis', '~> 0.6'
gem 'redis-rails', '~> 5.0'
gem 'sidekiq', '~> 5.2'
gem 'sidekiq-scheduler', '~> 3.0'

# MIDDLEWARE
gem 'rack-heartbeat', '~> 1.1'
gem 'rack-timeout', '~> 0.5'
gem 'rack-attack', '~> 6.1'
gem 'rack-cors', '~> 1.0'

# REPORTING & MONITORING
gem 'sentry-raven', '~> 2.11'
gem 'puma_worker_killer', '~> 0.1.1'

# FILE HANDING
gem 'rubyzip', '~> 2.0'
gem 'combine_pdf', '~> 1.0', '>= 1.0.16'

# DEVELOPMENT
group :development do
  gem 'better_errors'
  gem 'binding_of_caller', platforms: [:mri]
  gem 'brakeman'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # gem 'spring-commands-rspec'
end

# TESTING
group :test, :development do
  gem 'dotenv-rails', '~> 2.7'
  gem 'bullet'
  gem 'rspec-rails'
  # gem 'rubocop', '~> 0.58', require: false
end

group :test do
  gem 'mongoid-rspec'
  gem 'shoulda-matchers'
  gem 'mailcatcher'
  gem 'rails-controller-testing'
  gem 'database_cleaner'
  gem 'fuubar', '~> 2.5'
  gem 'rspec-sidekiq'
  gem 'terminal-table'
  gem 'timecop'
  # gem 'vcr'
  # gem 'stripe-ruby-mock', require: false
  gem 'webmock'
  gem 'mock_redis'
  gem 'simplecov', '~> 0.17.0', require: false
end

# DEBUG/PRY
group :test, :development do
  gem 'byebug' # -
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

# GUARD / AUTO TEST
group :test, :development do
  gem 'factory_bot_rails', require: false
  gem 'faker', require: false
end

