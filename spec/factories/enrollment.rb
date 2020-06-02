FactoryBot.define do
  sequence(:enrollment_reference) { |n| "E#{n+1}#{n}bC#{n}" }

  factory :enrollment do
    reference { generate(:enrollment_reference) }
    cancel_reason { nil }
    status { 'started' }
    progress { 0 }
    is_deleted { false }


    association :payment, factory: [:payment]
    association :learner, factory: [:user]
    association :course, factory: [:course]
  end

  factory :invalid_enrollment, parent: :enrollment do
    reference { nil }
    payment { nil }
    learner { nil }
    course { nil }
  end
end
