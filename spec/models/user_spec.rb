require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }
  let(:seller) { create(:user, :seller) }

  describe "validations" do

    context "when user has valid attributes" do
      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when name is missing" do
      it "is invalid" do
        user = build(:user, name: nil)
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("can't be blank")
      end
    end

    context "when email is missing" do
      it "is invalid" do
        user = build(:user, email: nil)
        expect(user).not_to be_valid
      end
    end

    context "when email is duplicated" do
      it "is invalid" do
        create(:user, email: "same@example.com")
        duplicate = build(:user, email: "same@example.com")
        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:email]).to include("has already been taken")
      end
    end

  end

  describe "roles" do

    context "when user is a buyer" do
      it "returns true for buyer?" do
        expect(user.buyer?).to be_truthy
      end

      it "returns false for seller?" do
        expect(user.seller?).to be_falsy
      end
    end

    context "when user is a seller" do
      it "returns true for seller?" do
        expect(seller.seller?).to be_truthy
      end

      it "returns false for buyer?" do
        expect(seller.buyer?).to be_falsy
      end
    end

  end

  describe "status" do

    context "when user is enabled" do
      it "returns true for enabled?" do
        expect(user.enabled?).to be_truthy
      end
    end

    context "when user is disabled" do
      let(:disabled_user) { create(:user, :disabled) }

      it "returns false for enabled?" do
        expect(disabled_user.enabled?).to be_falsy
      end
    end

  end

  describe "role values" do
    it "includes seller and buyer" do
      expect(User::ROLES).to include("seller", "buyer")
    end
  end

end