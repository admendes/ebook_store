require 'rails_helper'

RSpec.describe Ebook, type: :model do
  let(:seller) { create(:user, :seller) }
  let(:ebook)  { create(:ebook, user: seller) }

  # ─── Validations ───────────────────────────────────────────────
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:price) }
    it { is_expected.to validate_inclusion_of(:status).in_array(Ebook::STATUSES) }

    context "price numericality" do
      it "is invalid with a negative price" do
        ebook = build(:ebook, price: -1, user: seller)
        expect(ebook).not_to be_valid
      end

      it "is valid with a price of zero" do
        ebook = build(:ebook, price: 0, user: seller)
        expect(ebook).to be_valid
      end

      it "is valid with a positive price" do
        expect(ebook.price).to be > 0
        expect(ebook).to be_valid
      end
    end

    context "status inclusion" do
      it "is invalid with an unknown status" do
        ebook = build(:ebook, status: "unknown", user: seller)
        expect(ebook).not_to be_valid
      end
    end
  end

  # ─── Associations ──────────────────────────────────────────────
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:purchases).dependent(:destroy) }
    it { is_expected.to have_many(:ebook_tags).dependent(:destroy) }
    it { is_expected.to have_many(:tags).through(:ebook_tags) }
    it { is_expected.to have_many(:visitors).dependent(:destroy) }
  end

  # ─── Scopes ────────────────────────────────────────────────────
  describe "scopes" do
    describe ".published" do
      it "returns only live ebooks" do
        draft_ebook   = create(:ebook, user: seller)
        live_ebook    = create(:ebook, :live, user: seller)

        expect(Ebook.published).to include(live_ebook)
        expect(Ebook.published).not_to include(draft_ebook)
      end
    end

    describe ".by_seller" do
      it "returns only ebooks from a specific seller" do
        other_seller  = create(:user, :seller)
        my_ebook      = create(:ebook, user: seller)
        other_ebook   = create(:ebook, user: other_seller)

        expect(Ebook.by_seller(seller)).to include(my_ebook)
        expect(Ebook.by_seller(seller)).not_to include(other_ebook)
      end
    end

    describe ".drafts" do
      it "returns only draft ebooks" do
        draft_ebook   = create(:ebook, user: seller)
        live_ebook    = create(:ebook, :live, user: seller)

        expect(Ebook.drafts).to include(draft_ebook)
        expect(Ebook.drafts).not_to include(live_ebook)
      end
    end

    describe ".pending_review" do
      it "returns only pending ebooks" do
        pending_ebook = create(:ebook, :pending, user: seller)
        draft_ebook   = create(:ebook, user: seller)

        expect(Ebook.pending_review).to include(pending_ebook)
        expect(Ebook.pending_review).not_to include(draft_ebook)
      end
    end

    describe "scope chaining" do
      it "can chain published and by_seller" do
        live_ebook    = create(:ebook, :live, user: seller)
        other_seller  = create(:user, :seller)
        other_ebook   = create(:ebook, :live, user: other_seller)

        result = Ebook.published.by_seller(seller)
        expect(result).to include(live_ebook)
        expect(result).not_to include(other_ebook)
      end
    end
  end

  # ─── Instance Methods ──────────────────────────────────────────
  describe "instance methods" do
    describe "#advance_status!" do
      it "moves from draft to pending" do
        ebook.advance_status!
        expect(ebook.reload.status).to eq("pending")
      end

      it "moves from pending to live" do
        pending_ebook = create(:ebook, :pending, user: seller)
        pending_ebook.advance_status!
        expect(pending_ebook.reload.status).to eq("live")
      end
    end

    describe "#submit_for_review!" do
      it "changes status from draft to pending" do
        ebook.submit_for_review!
        expect(ebook.reload.status).to eq("pending")
      end
    end

    describe "#publish!" do
      it "changes status to live" do
        ebook.publish!
        expect(ebook.reload.status).to eq("live")
      end
    end

    describe "#live?" do
      it "returns true when status is live" do
        live_ebook = create(:ebook, :live, user: seller)
        expect(live_ebook.live?).to be_truthy
      end

      it "returns false when status is draft" do
        expect(ebook.live?).to be_falsy
      end
    end

    describe "statistics" do
      it "tracks purchase_count" do
        expect(ebook.purchase_count).to eq(0)
      end

      it "tracks page_visit_count" do
        expect(ebook.page_visit_count).to eq(0)
      end

      it "tracks preview_view_count" do
        expect(ebook.preview_view_count).to eq(0)
      end
    end
  end
end
