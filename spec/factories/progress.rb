FactoryBot.define do
  factory :progress do
    # course
    # lesson
    # enrollment
    status { 'started' }


    association :course, factory: [:course]
    association :lesson, factory: [:lesson]
    association :enrollment, factory: [:enrollment]
  end

  factory :invalid_progress, parent: :progress do
    course { nil }
    lesson { nil }
    enrollment { nil }
    status { nil }
  end
end
