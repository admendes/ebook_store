RSpec.shared_examples "a publishable resource" do
  describe "status transitions" do

    context "when draft" do
      it "can be submitted for review" do
        subject.submit_for_review!
        expect(subject.reload.status).to eq("pending")
      end
    end

    context "when pending" do
      before { subject.update_column(:status, "pending") }

      it "can be published" do
        subject.publish!
        expect(subject.reload.status).to eq("live")
      end
    end

    context "when live" do
      before { subject.update_column(:status, "live") }

      it "is live" do
        expect(subject.live?).to be_truthy
      end
    end
  end
end