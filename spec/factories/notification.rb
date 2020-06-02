FactoryBot.define do
  factory :notification do
    action { 'message_created' }

    association :recipient, factory: [:user]
    association :actor, factory: [:user]
    association :notifiable, factory: [:message]
  end

  factory :invalid_notification, parent: :notification do
    action { nil }
    notifiable { nil }
  end
end
