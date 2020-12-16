FactoryBot.define do
  factory :answer do
    body { 'Answer body' }

    trait :invalid do
      body { nil }
    end
  end
end
