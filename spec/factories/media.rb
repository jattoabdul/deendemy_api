FactoryBot.define do
  factory :media do
    type { %w(image pdf video ppt audio text).sample }
    title { Faker::Lorem.sentence(word_count: 2) }
    description { Faker::Lorem.paragraph }
    item { Faker::Internet.url }
    # is_deleted { false }

    association :user, factory: [:user]
    association :message, factory: [:message]
  end

  factory :invalid_media, parent: :media do
    title { nil }
  end
end
