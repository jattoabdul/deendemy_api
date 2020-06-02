FactoryBot.define do
  factory :progress do
    status { 'started' }


    association :course, factory: [:course]
    association :lesson, factory: [:lesson]
    association :enrollment, factory: [:enrollment]

    trait :completed do
      status { 'completed' }
    end
  end

  factory :invalid_progress, parent: :progress do
    course { nil }
    lesson { nil }
    enrollment { nil }
    status { nil }
  end
end
