FactoryBot.define do
  factory :purchase do
    association :buyer, factory: [:user, :buyer]
    association :ebook, factory: [:ebook, :live]
    amount           { Faker::Commerce.price(range: 9.99..49.99) }
    seller_commission { |p| p.amount ? (p.amount * 0.10).round(2) : 0 }
  end
end