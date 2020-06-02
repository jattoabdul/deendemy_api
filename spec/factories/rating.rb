FactoryBot.define do
  factory :rating do
    rating { rand(0..5) }
    review { nil }
    status { 'published' }
    is_deleted { false }

    association :course, factory: [:course]
    association :user, factory: [:user]
  end

  factory :invalid_rating, parent: :rating do
    user { nil }
    course { nil }
    rating { nil }
    status { nil }
    is_deleted { nil }
  end
end
