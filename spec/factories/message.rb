FactoryBot.define do
  factory :message do
    body { Faker::Lorem.paragraph(sentence_count: 3, supplemental: true) }
    priority { 'normal' }
    read { false }
    is_deleted { false }

    association :conversation, factory: [:conversation]
    association :sender, factory: [:user]
    association :receiver, factory: [:user]
  end

  factory :invalid_message, parent: :message do
    sender_id { nil }
    receiver_id { nil }
    conversation_id { nil }
    body { nil }
  end
end
