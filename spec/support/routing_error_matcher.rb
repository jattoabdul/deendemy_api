class Helper
  include RSpec::Rails::Matchers::RoutingMatchers

  RSpec::Matchers.define :raise_routing_error do
    # makes sure we route to application#routing_Error, where previously we would
    # raise an ActionController::RoutingError, which we can't rescue_from.
    match do |actual|
      expected = { controller: 'application', action: 'routing_error', path: actual.values.first }
      RouteToMatcher.new(self, expected).matches?(actual)
    end

    failure_message do
      "Expected that #{actual} would raise a routing error"
    end

    failure_message_when_negated do
      "Expected that #{actual} would not raise a routing error"
    end
  end
end
