class ApplicationMailer < ActionMailer::Base
    include ActiveSupport::NumberHelper

  default(
    from: Deendemy::Settings.email,
    reply_to: DeenDemy::Settings.email
  )
  layout 'mailer'
end
