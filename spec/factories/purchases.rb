FactoryBot.define do
  factory :purchase do
    association :buyer, factory: [:user, :buyer]
    association :ebook, factory: [:ebook, :live]
    amount { 19.99 }
    seller_commission { 2.00 }
  end
end