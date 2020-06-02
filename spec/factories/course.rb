FactoryBot.define do
  factory :course do
    title { Faker::Educator.course_name }
    subtitle { Faker::Lorem.sentence(word_count: 6) }
    type { 'paid' }
    price_pence { rand(100..3000) }
    currency_iso { 'USD' }
    status { 'draft' }
    copy_text { false }
    seo { {} }
    language { 'english' }
    level { 'everyone' }
    configs { [] }


    association :tutor, factory: [:user]
    association :label, factory: [:media]
    # association :introduction, factory: [:lesson]
  end

  factory :invalid_course, parent: :course do
    title { nil }
    price_pence { nil }
    currency_iso { nil }
  end
end
