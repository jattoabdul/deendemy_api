FactoryBot.define do
  factory :wishlist do
    items { [] }
    association :user, factory: [:user]

    trait :with_items do
      after(:create) do |wishlist|
        items = create_list(:course, 2)
        wishlist.items = items
        wishlist.save
      end
    end
  end

  factory :invalid_wishlist, parent: :wishlist do
    user_id { nil }
    items { nil }
  end
end
