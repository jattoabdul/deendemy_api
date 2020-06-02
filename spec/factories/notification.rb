FactoryBot.define do
  factory :notification do
    action { 'message_created' }
    read_at { Time.current }
    is_deleted { false }
    data { {} }

    association :recipient, factory: [:user]
    association :actor, factory: [:user]
    association :notifiable, factory: [:message]
  end

  factory :invalid_notification, parent: :notification do
    action { nil }
  end
end
