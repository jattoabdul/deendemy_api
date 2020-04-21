class ApplicationMailer < ActionMailer::Base
  include ActiveSupport::NumberHelper

  app_name_with_email = %("#{Deendemy::Settings.name}" <#{Deendemy::Settings.support_email}>)
    
  default(
    from: app_name_with_email,
    reply_to: app_name_with_email
  )

  layout 'mailer'
end
