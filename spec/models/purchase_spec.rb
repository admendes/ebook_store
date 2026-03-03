require 'rails_helper'

RSpec.describe Purchase, type: :model do

  let(:seller)   { create(:user, :seller) }
  let(:buyer)    { create(:user, :buyer) }
  let(:ebook)    { create(:ebook, :live, user: seller, price: 20.00) }
  let(:purchase) { create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00) }

  # ─── Validations ───────────────────────────────────────────────
  describe "validations" do
    it "is valid with valid attributes" do
      expect(purchase).to be_valid
    end

    it "is invalid without an amount" do
      purchase = build(:purchase, amount: nil)
      expect(purchase).not_to be_valid
    end

    it "is invalid with a zero amount" do
      purchase = build(:purchase, amount: 0)
      expect(purchase).not_to be_valid
    end
  end

  # ─── Associations ──────────────────────────────────────────────
  describe "associations" do
    it { is_expected.to belong_to(:buyer).class_name("User") }
    it { is_expected.to belong_to(:ebook) }
  end

  # ─── Data integrity ────────────────────────────────────────────
  describe "data integrity" do
    it "records the correct purchase amount" do
      expect(purchase.amount).to eq(20.00)
    end

    it "records the correct seller commission" do
      expect(purchase.seller_commission).to eq(2.00)
    end

    it "commission is 10% of the amount" do
      expect(purchase.seller_commission).to eq(purchase.amount * 0.10)
    end
  end

end