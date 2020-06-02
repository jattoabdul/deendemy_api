require 'database_cleaner'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.orm = 'mongoid'
    DatabaseCleaner.strategy = :truncation
  end

  # config.before :each do
  #   Mongoid.purge!
  # end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  rescue StandardError
    nil
  end
end
