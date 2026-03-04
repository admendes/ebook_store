RSpec.shared_context "authenticated user" do
  let(:current_user) { create(:user) }

  before do
    session[:user_id] = current_user.id
  end
end

RSpec.shared_context "authenticated seller" do
  let(:current_user) { create(:user, :seller) }
  let!(:seller_ebooks) { create_list(:ebook, 3, user: current_user) }

  before do
    session[:user_id] = current_user.id
  end
end

RSpec.shared_context "authenticated buyer" do
  let(:current_user) { create(:user, :buyer, balance: 200) }

  before do
    session[:user_id] = current_user.id
  end
end