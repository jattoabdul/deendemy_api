FactoryBot.define do
  factory :conversation do
    is_deleted { false }


    association :sender, factory: [:user]
    association :receiver, factory: [:user]
  end

  factory :invalid_conversation, parent: :conversation do
    sender { nil }
    receiver { nil }
  end
end
