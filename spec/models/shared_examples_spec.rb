require 'rails_helper'

# ─── Shared Examples for Models ──────────────────────────────────
RSpec.describe "Shared Model Behaviors" do
  describe User, type: :model do
    subject { create(:user) }

    it_behaves_like "a model with status"
    it_behaves_like "a model with timestamps"
  end

  describe Ebook, type: :model do
    let(:seller) { create(:user, :seller) }
    subject      { create(:ebook, user: seller) }

    it_behaves_like "a model with status"
    it_behaves_like "a model with timestamps"
    it_behaves_like "a publishable resource"
  end

  describe Purchase, type: :model do
    subject { create(:purchase) }

    it_behaves_like "a model with timestamps"
  end
end

# ─── Shared Contexts ─────────────────────────────────────────────
RSpec.describe "Shared Contexts", type: :model do
  describe "with published ebooks context" do
    include_context "with published ebooks"

    it "has published ebooks available" do
      expect(published_ebooks.count).to eq(3)
      expect(published_ebooks.first.status).to eq("live")
    end

    it "has draft ebooks available" do
      expect(draft_ebooks.count).to eq(2)
      expect(draft_ebooks.first.status).to eq("draft")
    end

    it "can filter published ebooks" do
      expect(Ebook.published).to match_array(published_ebooks)
    end

    it "can filter by seller" do
      expect(Ebook.by_seller(seller)).to match_array(published_ebooks + draft_ebooks)
    end
  end

  describe "with purchase setup context" do
    include_context "with purchase setup"

    it "has seller with zero balance" do
      expect(seller.balance).to eq(0)
    end

    it "has buyer with sufficient balance" do
      expect(buyer.balance).to be >= ebook.price
    end

    it "has a live ebook ready for purchase" do
      expect(ebook.live?).to be_truthy
    end

    it "buyer can afford the ebook" do
      expect(buyer.balance).to be >= ebook.price
    end
  end

  describe "frozen time context" do
    include_context "frozen time"

    it "freezes time to the specified moment" do
      expect(Time.current).to eq(frozen_time)
    end

    it "can test time-sensitive features" do
      user = create(:user, last_password_change: frozen_time - 7.months)
      expect(user.last_password_change).to be < 6.months.ago
    end
  end
end
