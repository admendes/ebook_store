require 'rails_helper'

RSpec.describe Ebook, type: :model do

  let(:seller) { create(:user, :seller) }
  let(:ebook) { create(:ebook, user: seller) }

  describe "validations" do

    context "when ebook has valid attributes" do
      it "is valid" do
        expect(ebook).to be_valid
      end
    end

    context "when title is missing" do
      it "is invalid" do
        ebook = build(:ebook, title: nil, user: seller)
        expect(ebook).not_to be_valid
        expect(ebook.errors[:title]).to include("can't be blank")
      end
    end

    context "when price is missing" do
      it "is invalid" do
        ebook = build(:ebook, price: nil, user: seller)
        expect(ebook).not_to be_valid
      end
    end

    context "when price is negative" do
      it "is invalid" do
        ebook = build(:ebook, price: -1, user: seller)
        expect(ebook).not_to be_valid
      end
    end

  end

  describe "status workflow" do

    context "when ebook is draft" do
      it "has draft status by default" do
        expect(ebook.status).to eq("draft")
      end

      it "is not live" do
        expect(ebook.live?).to be_falsy
      end

      it "advances to pending" do
        ebook.advance_status!
        expect(ebook.status).to eq("pending")
      end
    end

    context "when ebook is pending" do
      let(:ebook) { create(:ebook, :pending, user: seller) }

      it "has pending status" do
        expect(ebook.status).to eq("pending")
      end

      it "advances to live" do
        ebook.advance_status!
        expect(ebook.status).to eq("live")
      end
    end

    context "when ebook is live" do
      let(:ebook) { create(:ebook, :live, user: seller) }

      it "has live status" do
        expect(ebook.status).to eq("live")
      end

      it "is live" do
        expect(ebook.live?).to be_truthy
      end
    end

  end

  describe "status values" do
    it "includes all three statuses" do
      expect(Ebook::STATUSES).to include("draft", "pending", "live")
    end
  end

  describe "price" do
    it "is greater than zero" do
      expect(ebook.price).to be > 0
    end

    it "is between 0 and 1000" do
      expect(ebook.price).to be_between(0, 1000)
    end
  end

end