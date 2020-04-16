FactoryBot.define do
  factory :category do
    name { Faker::Educator.unique.subject }
  end

  factory :invalid_category, parent: :category do
    name { nil }
  end
end
