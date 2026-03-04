require 'rails_helper'

RSpec.describe EbooksController, type: :controller do

  # ─── Unauthenticated access ──────────────────────────────────
  describe "unauthenticated access" do
    describe "GET #index" do
      before { get :index }
      it_behaves_like "requires authentication"
    end

    describe "GET #new" do
      before { get :new }
      it_behaves_like "requires authentication"
    end

    describe "GET #show" do
      before do
        seller = create(:user, :seller)
        ebook  = create(:ebook, user: seller)
        get :show, params: { id: ebook.id }
      end
      it_behaves_like "requires authentication"
    end
  end

  # ─── Authenticated access ────────────────────────────────────
  describe "authenticated access", :authenticated do

    describe "GET #index" do
      include_context "with published ebooks"

      before { get :index }

      it "returns success" do
        expect(response).to be_successful
      end

      it "assigns all ebooks" do
        expect(assigns(:ebooks)).to be_present
      end
    end

    describe "GET #new" do
      before { get :new }

      it "returns success" do
        expect(response).to be_successful
      end

      it "assigns a new ebook" do
        expect(assigns(:ebook)).to be_a_new(Ebook)
      end
    end

    describe "GET #show" do
      include_context "with published ebooks"

      before { get :show, params: { id: published_ebooks.first.id } }

      it "returns success" do
        expect(response).to be_successful
      end

      it "increments page visit count" do
        expect(assigns(:ebook).page_visit_count).to eq(1)
      end
    end

  end

end