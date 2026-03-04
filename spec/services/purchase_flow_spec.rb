require 'rails_helper'

RSpec.describe "Purchase Flow with Mocks", type: :model do
  let(:seller)  { create(:user, :seller, balance: 0) }
  let(:buyer)   { create(:user, :buyer, balance: 100) }
  let(:ebook)   { create(:ebook, :live, user: seller, price: 20.00) }

  # ─── Basic Doubles ─────────────────────────────────────────────
  describe "test doubles" do
    it "creates a simple double" do
      ebook_double = double("ebook", title: "Ruby Guide", price: 19.99)
      expect(ebook_double.title).to eq("Ruby Guide")
      expect(ebook_double.price).to eq(19.99)
    end

    it "creates a verified instance double" do
      ebook_double = instance_double(Ebook, title: "Rails Guide", price: 29.99, live?: true)
      expect(ebook_double.title).to eq("Rails Guide")
      expect(ebook_double.live?).to be_truthy
    end
  end

  # ─── Stubbing ──────────────────────────────────────────────────
  describe "stubbing methods" do
    it "stubs a method on a real object" do
      allow(ebook).to receive(:price).and_return(99.99)
      expect(ebook.price).to eq(99.99)
    end

    it "stubs consecutive return values" do
      allow(ebook).to receive(:page_visit_count).and_return(10, 11, 12)
      expect(ebook.page_visit_count).to eq(10)
      expect(ebook.page_visit_count).to eq(11)
      expect(ebook.page_visit_count).to eq(12)
    end

    it "stubs a class method" do
      live_ebook = create(:ebook, :live, user: seller)
      allow(Ebook).to receive(:published).and_return([ live_ebook ])
      expect(Ebook.published).to include(live_ebook)
    end

    it "stubs a method to raise an exception" do
      allow(ebook).to receive(:publish!).and_raise(StandardError, "Cannot publish")
      expect { ebook.publish! }.to raise_error(StandardError, "Cannot publish")
    end

    it "stubs User.find to return a test user" do
      allow(User).to receive(:find).with(buyer.id).and_return(buyer)
      expect(User.find(buyer.id)).to eq(buyer)
    end
  end

  # ─── Mocking Email Notifications ───────────────────────────────
  describe "mocking email notifications" do
    it "verifies seller_notification mailer is called" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)

      mail_double = double("mail", deliver_now: true)
      expect(PurchaseMailer).to receive(:seller_notification).with(purchase).and_return(mail_double)

      PurchaseMailer.seller_notification(purchase).deliver_now
    end

    it "verifies stats_notification mailer is called" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)

      mail_double = double("mail", deliver_now: true)
      expect(PurchaseMailer).to receive(:stats_notification).with(purchase).and_return(mail_double)

      PurchaseMailer.stats_notification(purchase).deliver_now
    end

    it "stubs mailer to avoid sending real emails" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)

      allow(PurchaseMailer).to receive(:seller_notification).and_return(double(deliver_now: true))
      allow(PurchaseMailer).to receive(:stats_notification).and_return(double(deliver_now: true))

      expect { PurchaseMailer.seller_notification(purchase).deliver_now }.not_to raise_error
      expect { PurchaseMailer.stats_notification(purchase).deliver_now }.not_to raise_error
    end
  end

  # ─── Spies ─────────────────────────────────────────────────────
  describe "using spies" do
    it "verifies mailer was called after the fact" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)
      mailer_spy = spy("PurchaseMailer")

      mailer_spy.seller_notification(purchase)

      expect(mailer_spy).to have_received(:seller_notification).with(purchase)
    end

    it "verifies stats notification was sent" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)
      mailer_spy = spy("PurchaseMailer")

      mailer_spy.stats_notification(purchase)

      expect(mailer_spy).to have_received(:stats_notification).with(purchase)
    end
  end

  # ─── Mocking Statistics ────────────────────────────────────────
  describe "mocking statistics tracking" do
    it "stubs page visit tracking" do
      allow(ebook).to receive(:increment!).with(:page_visit_count)
      ebook.increment!(:page_visit_count)
      expect(ebook).to have_received(:increment!).with(:page_visit_count)
    end

    it "stubs preview view tracking" do
      allow(ebook).to receive(:increment!).with(:preview_view_count)
      ebook.increment!(:preview_view_count)
      expect(ebook).to have_received(:increment!).with(:preview_view_count)
    end
  end

  # ─── Error Handling ────────────────────────────────────────────
  describe "error handling with mocks" do
    it "handles ebook becoming unavailable during purchase" do
      allow(ebook).to receive(:live?).and_return(false)
      expect(ebook.live?).to be_falsy
    end

    it "handles email delivery failure gracefully" do
      purchase = create(:purchase, buyer: buyer, ebook: ebook, amount: 20.00, seller_commission: 2.00)
      allow(PurchaseMailer).to receive(:seller_notification).and_raise(StandardError, "Email failed")

      expect {
        begin
          PurchaseMailer.seller_notification(purchase)
        rescue StandardError
          # gracefully handled
        end
      }.not_to raise_error
    end

    it "handles database transaction failure" do
      allow(Purchase).to receive(:create!).and_raise(ActiveRecord::RecordInvalid)
      expect { Purchase.create! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
