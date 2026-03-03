FactoryBot.define do
  factory :user do
    name { "Test User" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    role { "buyer" }
    status { "enabled" }
    balance { 100.0 }
    last_password_change { Time.current }

    trait :seller do
      role { "seller" }
      name { "Test Seller" }
    end

    trait :buyer do
      role { "buyer" }
      name { "Test Buyer" }
    end

    trait :disabled do
      status { "disabled" }
    end
  end
end