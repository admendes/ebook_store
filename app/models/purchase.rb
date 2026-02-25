class Purchase < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :ebook

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :seller_commission, presence: true
end