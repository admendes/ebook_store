FactoryBot.define do
  factory :ebook do
    title { "Test Ebook" }
    description { "A great ebook" }
    price { 19.99 }
    status { "draft" }
    association :user, factory: [:user, :seller]

    trait :pending do
      status { "pending" }
    end

    trait :live do
      status { "live" }
    end
  end
end