DeviseTokenAuth.setup do |config|
  config.change_headers_on_each_request = false
  # config.enable_standard_devise_support = true
  # bypass_sign_in = false
  config.token_cost = Rails.env.test? ? 4 : 10
  config.token_lifespan = 2.weeks
  config.max_number_of_devices = 5
end
