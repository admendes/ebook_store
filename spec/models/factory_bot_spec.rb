require 'rails_helper'

RSpec.describe "Factory Bot and Faker", type: :model do

  # ─── User Factory ──────────────────────────────────────────────
  describe "User factory" do

    it "creates a valid user with Faker data" do
      user = create(:user)
      expect(user).to be_valid
      expect(user.name).to be_present
      expect(user.email).to be_present
    end

    it "creates a seller with :seller trait" do
      seller = create(:user, :seller)
      expect(seller.seller?).to be_truthy
    end

    it "creates a disabled user with :disabled trait" do
      user = create(:user, :disabled)
      expect(user.enabled?).to be_falsy
    end

    it "creates a user with ebooks using transient attribute" do
      seller = create(:user, :seller, :with_ebooks, ebooks_count: 3)
      expect(seller.ebooks.count).to eq(3)
    end

    it "builds a user without saving to database" do
      user = build(:user)
      expect(user.id).to be_nil
    end

    it "builds a stubbed user" do
      user = build_stubbed(:user)
      expect(user.name).to be_present
      expect(user).not_to be_a_new_record
    end

    it "returns attributes hash" do
      attrs = attributes_for(:user)
      expect(attrs).to include(:name, :email, :password)
    end

    it "generates unique emails" do
      user1 = create(:user)
      user2 = create(:user)
      expect(user1.email).not_to eq(user2.email)
    end

  end

  # ─── Ebook Factory ─────────────────────────────────────────────
  describe "Ebook factory" do

    let(:seller) { create(:user, :seller) }

    it "creates a valid ebook with Faker data" do
      ebook = create(:ebook, user: seller)
      expect(ebook).to be_valid
      expect(ebook.title).to be_present
      expect(ebook.price).to be > 0
    end

    it "creates a draft ebook by default" do
      ebook = create(:ebook, user: seller)
      expect(ebook.status).to eq("draft")
    end

    it "creates a live ebook with :live trait" do
      ebook = create(:ebook, :live, user: seller)
      expect(ebook.live?).to be_truthy
    end

    it "creates an expensive ebook with :expensive trait" do
      ebook = create(:ebook, :expensive, user: seller)
      expect(ebook.price).to be >= 79.99
    end

    it "creates an ebook with purchases using transient attribute" do
      ebook = create(:ebook, :live, :with_purchases, user: seller, purchases_count: 3)
      expect(ebook.purchases.count).to eq(3)
    end

    it "generates unique titles" do
      ebook1 = create(:ebook, user: seller)
      ebook2 = create(:ebook, user: seller)
      expect(ebook1.title).not_to eq(ebook2.title)
    end

    it "can combine multiple traits" do
      ebook = create(:ebook, :live, :expensive, user: seller)
      expect(ebook.live?).to be_truthy
      expect(ebook.price).to be >= 79.99
    end

  end

  # ─── Purchase Factory ──────────────────────────────────────────
  describe "Purchase factory" do

    it "creates a valid purchase" do
      purchase = create(:purchase)
      expect(purchase).to be_valid
      expect(purchase.amount).to be > 0
    end

    it "creates a purchase with correct commission" do
      purchase = create(:purchase, amount: 20.00, seller_commission: 2.00)
      expect(purchase.seller_commission).to eq(purchase.amount * 0.10)
    end

    it "creates a purchase with specific buyer and ebook" do
      buyer  = create(:user, :buyer)
      seller = create(:user, :seller)
      ebook  = create(:ebook, :live, user: seller)

      purchase = create(:purchase, buyer: buyer, ebook: ebook)
      expect(purchase.buyer).to eq(buyer)
      expect(purchase.ebook).to eq(ebook)
    end

  end

  # ─── Tag Factory ───────────────────────────────────────────────
  describe "Tag factory" do

    it "creates a valid tag" do
      tag = create(:tag)
      expect(tag).to be_valid
      expect(tag.name).to be_present
    end

    it "generates unique tag names" do
      tag1 = create(:tag)
      tag2 = create(:tag)
      expect(tag1.name).not_to eq(tag2.name)
    end

  end

  # ─── Complex Scenarios ─────────────────────────────────────────
  describe "complex factory scenarios" do

    it "creates a complete purchase flow" do
      seller   = create(:user, :seller, balance: 0)
      buyer    = create(:user, :buyer, balance: 100)
      ebook    = create(:ebook, :live, user: seller, price: 20.00)
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)

      expect(purchase.buyer).to eq(buyer)
      expect(purchase.ebook).to eq(ebook)
      expect(purchase.ebook.user).to eq(seller)
    end

    it "creates a seller with multiple ebooks of different statuses" do
      seller        = create(:user, :seller)
      draft_ebook   = create(:ebook, :draft, user: seller)
      pending_ebook = create(:ebook, :pending, user: seller)
      live_ebook    = create(:ebook, :live, user: seller)

      expect(seller.ebooks.count).to eq(3)
      expect(Ebook.drafts).to include(draft_ebook)
      expect(Ebook.pending_review).to include(pending_ebook)
      expect(Ebook.published).to include(live_ebook)
    end

  end

end