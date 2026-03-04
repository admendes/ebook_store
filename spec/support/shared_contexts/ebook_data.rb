RSpec.shared_context "with published ebooks" do
  let(:seller)           { create(:user, :seller) }
  let!(:published_ebooks) { create_list(:ebook, 3, :live, user: seller) }
  let!(:draft_ebooks)     { create_list(:ebook, 2, :draft, user: seller) }
end

RSpec.shared_context "with purchase setup" do
  let(:seller) { create(:user, :seller, balance: 0) }
  let(:buyer)  { create(:user, :buyer, balance: 200) }
  let(:ebook)  { create(:ebook, :live, user: seller, price: 29.99) }
end
