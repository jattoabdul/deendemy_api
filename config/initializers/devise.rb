Devise.setup do |config|
  # ==> Mailer Configuration
  config.mailer_sender = "support@deendemy.com"

  # ==> ORM configuration
  require 'devise/orm/mongoid'

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]

  # ==> Config for Parent Controller
  # config.parent_controller = 'BaseController'

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 11

  # ==> Configuration for :confirmable
  config.reconfirmable = true
  config.confirmation_keys = [ :email ]
  # config.allow_unconfirmed_access_for = 365.days

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :lockable
  config.reset_password_within = 6.hours

  # ==> Navigation configuration
  config.sign_out_via = :delete
  config.navigational_formats = [:json]

  # ==> OmniAuth
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

end