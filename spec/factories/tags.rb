FactoryBot.define do
  factory :tag do
    sequence(:name) { |n| "#{Faker::Book.genre}-#{n}" }
  end
end