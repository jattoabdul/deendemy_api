FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    uid { email }
    # confirm_success_url { Faker::Internet.url }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    country { "Nigeria" }
    zip { Faker::Address.zip }
    state { Faker::Address.state_abbr }
    city { Faker::Address.city }
    street { Faker::Address.street_address }
    roles { ["learner"] }

    trait :teacher do
      roles { ["learner", "teacher"] }
    end

    trait :teacher_only do
      roles { ["teacher"] }
    end

    trait :admin do
      roles { ["learner", "teacher", "support", "admin"] }
    end

    trait :admin_only do
      roles { ["admin"] }
    end

    trait :support_only do
      roles { ["support"] }
    end

    trait :support do
      roles { ["learner", "support"] }
    end
  end
end
