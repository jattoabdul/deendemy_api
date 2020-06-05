FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    uid { email }
    # confirm_success_url { Faker::Internet.url }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country { 'Nigeria' }
    zip { Faker::Address.zip }
    state { Faker::Address.state_abbr }
    city { Faker::Address.city }
    street { Faker::Address.street_address }
    roles { ['learner'] }

    trait :without_cart do
      after(:create) do |user|
        user.cart.destroy
        user.save
      end
    end

    trait :without_wishlist do
      after(:create) do |user|
        user.wishlist.destroy
        user.save
      end
    end

    trait :teacher do
      roles { %w(learner teacher) }
    end

    trait :teacher_only do
      roles { ['teacher'] }
    end

    trait :admin do
      roles { %w(learner teacher support admin) }
    end

    trait :admin_only do
      roles { ['admin'] }
    end

    trait :support_only do
      roles { ['support'] }
    end

    trait :support do
      roles { %w(learner support) }
    end
  end

  factory :invalid_user, parent: :user do
    email { nil }
    uid { nil }
    zip { nil }
    country { nil }
    first_name { nil }
    last_name { nil }
  end
end
