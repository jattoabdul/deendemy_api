# spec/support/request_helpers.rb
module Request
  module JSONHelpers
    def parsed_body
      Oj.load(response.body)
    end
  end
end
