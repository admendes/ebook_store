require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user)   { create(:user) }
  let(:seller) { create(:user, :seller) }

  # ─── Validations ───────────────────────────────────────────────
  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    context "email" do
      it "is invalid without an email" do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end

      it "is invalid with a duplicate email" do
        create(:user, email: "same@example.com")
        duplicate = build(:user, email: "same@example.com")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("has already been taken")
      end

      it "is invalid with a bad format" do
        user = build(:user, email: "notanemail")
        expect(user).not_to be_valid
      end

      it "is valid with a correct format" do
        user = build(:user, email: "valid@example.com")
        expect(user).to be_valid
      end
    end

    context "role" do
      it { is_expected.to validate_inclusion_of(:role).in_array(User::ROLES) }
    end

    context "status" do
      it { is_expected.to validate_inclusion_of(:status).in_array(User::STATUSES) }
    end
  end

  # ─── Associations ──────────────────────────────────────────────
  describe "associations" do
    it { is_expected.to have_many(:ebooks).dependent(:destroy) }
    it { is_expected.to have_many(:purchases) }
    it { is_expected.to have_many(:purchased_ebooks).through(:purchases) }
  end

  # ─── Instance Methods ──────────────────────────────────────────
  describe "instance methods" do

    describe "#enable!" do
      it "sets status to enabled" do
        disabled_user = create(:user, :disabled)
        disabled_user.enable!
        expect(disabled_user.reload.status).to eq("enabled")
      end
    end

    describe "#disable!" do
      it "sets status to disabled" do
        user.disable!
        expect(user.reload.status).to eq("disabled")
      end
    end

    describe "#enabled?" do
      it "returns true when enabled" do
        expect(user.enabled?).to be_truthy
      end

      it "returns false when disabled" do
        disabled_user = create(:user, :disabled)
        expect(disabled_user.enabled?).to be_falsy
      end
    end

    describe "#seller?" do
      it "returns true for sellers" do
        expect(seller.seller?).to be_truthy
      end

      it "returns false for buyers" do
        expect(user.seller?).to be_falsy
      end
    end

    describe "#buyer?" do
      it "returns true for buyers" do
        expect(user.buyer?).to be_truthy
      end

      it "returns false for sellers" do
        expect(seller.buyer?).to be_falsy
      end
    end
  end

end