FactoryBot.define do
  factory :ebook do
    title       { Faker::Book.title }
    description { Faker::Lorem.paragraph(sentence_count: 3) }
    price       { Faker::Commerce.price(range: 9.99..49.99) }
    status      { "draft" }
    association :user, factory: [:user, :seller]

    trait :draft do
      status { "draft" }
    end

    trait :pending do
      status { "pending" }
    end

    trait :live do
      status { "live" }
    end

    trait :expensive do
      price { Faker::Commerce.price(range: 79.99..199.99) }
    end

    trait :with_purchases do
      transient do
        purchases_count { 3 }
      end

      after(:create) do |ebook, evaluator|
        create_list(:purchase, evaluator.purchases_count,
          ebook: ebook,
          amount: ebook.price,
          seller_commission: (ebook.price * 0.10).round(2)
        )
      end
    end
  end
end