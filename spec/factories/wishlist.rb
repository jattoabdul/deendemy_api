FactoryBot.define do
  factory :wishlist do
    # user

    association :user, factory: [:user]
  end

  factory :invalid_wishlist, parent: :wishlist do
    user { nil }
  end
end
