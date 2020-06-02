FactoryBot.define do
  factory :assessment do
    reference { generate(:lesson_reference) }
    title { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 2, supplemental: true) }
    status { 'published' }
    prerequisite { false }
    downloadable { false }
    can_discuss { false }
    position { generate(:lesson_position) }
    type { %w(quiz survey).sample }
    questions do
      [
          {
              type: %w(freeText oneChoice multiChoice rating).sample,
              text: Faker::Lorem.question,
              choices: [
                  {
                      value: Faker::Lorem.sentence,
                      is_correct: false
                  },
                  {
                      value: Faker::Lorem.sentence,
                      is_correct: true
                  }
              ]
          }
      ]
    end

    association :chapter, factory: [:chapter]
    association :content, factory: [:media]
    association :additional_resource, factory: [:media]
  end

  factory :invalid_assessment, parent: :assessment do
    reference { nil }
    title { nil }
    questions { nil }
  end
end
