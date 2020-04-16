FactoryBot.define do
  factory :event do
    name { 'category.created' }
    association :eventable, factory: [:category]
  end

  factory :invalid_event, parent: :event do
    name { nil }
    eventable { nil }
  end
end
