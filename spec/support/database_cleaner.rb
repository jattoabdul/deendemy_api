require 'database_cleaner'
# require 'database_cleaner/mongoid'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  rescue StandardError
    nil
  end
end
