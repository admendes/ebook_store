FactoryBot.define do
  factory :user do
    name     { Faker::Name.name }
    sequence(:email) { |n| "#{Faker::Internet.username}#{n}@example.com" }
    password { Faker::Internet.password(min_length: 8) }
    role     { "buyer" }
    status   { "enabled" }
    balance  { Faker::Commerce.price(range: 50.0..500.0) }
    last_password_change { Time.current }

    trait :seller do
      role { "seller" }
    end

    trait :buyer do
      role { "buyer" }
    end

    trait :disabled do
      status { "disabled" }
    end

    trait :with_ebooks do
      transient do
        ebooks_count { 3 }
      end

      after(:create) do |user, evaluator|
        create_list(:ebook, evaluator.ebooks_count, user: user)
      end
    end
  end
end