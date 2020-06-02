FactoryBot.define do
  factory :cart do
    expires_on { Faker::Date.forward(days: 7) }
    items { [] }

    association :user, factory: [:user]

    trait :with_items do
      after(:create) do |cart|
        items = create_list(:course, 2)
        cart.items = items
        cart.save
      end
    end
  end

  factory :invalid_cart, parent: :cart do
    user_id { nil }
    items { nil }
  end
end
