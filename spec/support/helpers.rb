module Helpers
  # Parses a JSON string into a hash
  #
  # @param response [ActionDispatch::Response]
  # @return [Hash]
  def json(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end
