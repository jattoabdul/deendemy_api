FactoryBot.define do
  sequence(:chapter_title) { |n| "chapter #{n}" }
  sequence(:chapter_reference) { |n| "A#{n+1}#{n}bC#{n}" }
  sequence(:chapter_position) { |n| (n-1) }

  factory :chapter do
    # course
    reference { generate(:chapter_reference) }
    title { generate(:chapter_title) }
    objective { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true) }
    position { generate(:chapter_position) }

    association :course, factory: [:course]
  end

  factory :invalid_chapter, parent: :chapter do
    course { nil }
    reference { nil }
    title { nil }
    position { nil }
  end
end
