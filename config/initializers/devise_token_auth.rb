DeviseTokenAuth.setup do |config|
  config.change_headers_on_each_request = false
  # config.enable_standard_devise_support = true
  # config.bypass_sign_in = false
  # config.require_client_password_reset_token = true
  config.send_confirmation_email = true
  config.remove_tokens_after_password_reset = true
  config.token_cost = Rails.env.test? ? 4 : 10
  config.token_lifespan = 2.weeks
  config.max_number_of_devices = 5
  config.default_password_reset_url = ENV.fetch('PASSWORD_RESET_URL', 'http://example.com/password-reset')
  config.default_confirm_success_url = ENV.fetch('SIGNUP_CONFIRM_SUCCESS_URL', 'http://example.com')
  # NB: pass this as param to signup if confirm success redirect does not work => "confirm_success_url": "https://jatto.tech",
end
