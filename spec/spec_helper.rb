require 'simplecov'
# require 'support/factory_bot'

SimpleCov.start 'rails' do
  add_filter '/.bundle/'
  add_filter 'vendor'
end

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end


  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object.
    mocks.verify_partial_doubles = true
  end

  # config.shared_context_metadata_behavior = :apply_to_host_groups

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 3

  Kernel.srand config.seed
end
