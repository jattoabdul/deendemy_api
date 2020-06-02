FactoryBot.define do
  factory :lesson_discussion do
    body { Faker::Lorem.paragraph }
    is_deleted { false }

    association :sender, factory: [:user]
    # association :parent, factory: [:lesson_discussion]
    # association :children, factory: [:lesson_discussion]
    association :course, factory: [:course]
    association :lesson, factory: [:lesson]
  end

  factory :invalid_lesson_discussion, parent: :lesson_discussion do
    body { nil }
    lesson { nil }
    sender { nil }
    course { nil }
  end
end
