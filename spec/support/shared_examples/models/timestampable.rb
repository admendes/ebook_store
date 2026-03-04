RSpec.shared_examples "a model with timestamps" do
  it "has a created_at timestamp" do
    expect(subject).to respond_to(:created_at)
  end

  it "has an updated_at timestamp" do
    expect(subject).to respond_to(:updated_at)
  end

  it "sets created_at on creation" do
    expect(subject.created_at).to be_present
  end

  it "sets updated_at on creation" do
    expect(subject.updated_at).to be_present
  end
end
