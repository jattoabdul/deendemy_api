FactoryBot.define do
  sequence(:payment_reference) { |n| "P#{n+1}#{n}bC#{n}" }

  factory :payment do
    # user
    reference { generate(:payment_reference) }
    currency_iso { 'USD' }
    tax_rate { 0.0 }
    subtotal_pence { 0 }
    tax_pence { 0 }
    total_pence { 0 }
    status { true }
    processor { 'paystack' }
    comment { nil }
    paid_at { Time.now }

    association :user, factory: [:user]
  end

  factory :invalid_payment, parent: :payment do
    reference { nil }
    user { nil }
  end
end
