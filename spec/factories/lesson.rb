FactoryBot.define do
  sequence(:lesson_title) { |n| "chapter #{n}" }
  sequence(:lesson_reference) { |n| "A#{n+1}#{n}bC#{n}" }
  sequence(:lesson_position) { |n| (n-1) }

  factory :lesson do
    reference { generate(:lesson_reference) }
    type { 'lecture' }
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true) }
    status { 'published' }
    prerequisite { false }
    downloadable { false }
    can_discuss { false }
    position { generate(:lesson_position) }

    association :chapter, factory: [:chapter]
    association :content, factory: [:media]
    association :additional_resource, factory: [:media]
  end

  factory :invalid_lesson, parent: :lesson do
    reference { nil }
    title { nil }
  end
end
