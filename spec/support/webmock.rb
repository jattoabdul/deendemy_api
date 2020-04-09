require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:suite) do
    # Disable network connection to strictly enforce external call mocks
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
