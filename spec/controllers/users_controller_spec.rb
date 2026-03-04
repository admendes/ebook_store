require 'rails_helper'

RSpec.describe UsersController, type: :controller do

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
  end

  # ─── Authenticated access ────────────────────────────────────
  describe "authenticated access", :authenticated do

    describe "GET #index" do
      before { get :index }

      it "returns success" do
        expect(response).to be_successful
      end

      it "assigns all users" do
        expect(assigns(:users)).to be_present
      end
    end

    describe "GET #new" do
      before { get :new }

      it "returns success" do
        expect(response).to be_successful
      end

      it "assigns a new user" do
        expect(assigns(:user)).to be_a_new(User)
      end
    end

    describe "POST #create" do
      context "with valid params" do
        let(:valid_params) { attributes_for(:user) }

        it "creates a new user" do
          expect {
            post :create, params: { user: valid_params }
          }.to change(User, :count).by(1)
        end

        it "redirects to the new user" do
          post :create, params: { user: valid_params }
          expect(response).to redirect_to(User.last)
        end
      end

      context "with invalid params" do
        let(:invalid_params) { attributes_for(:user, name: nil) }

        it "does not create a user" do
          expect {
            post :create, params: { user: invalid_params }
          }.not_to change(User, :count)
        end

        it "renders the new template" do
          post :create, params: { user: invalid_params }
          expect(response).to render_template(:new)
        end
      end
    end

    describe "PATCH #toggle_status" do
      let(:user) { create(:user) }

      it "toggles user status" do
        patch :toggle_status, params: { id: user.id }
        expect(user.reload.status).to eq("disabled")
      end

      it "redirects to users path" do
        patch :toggle_status, params: { id: user.id }
        expect(response).to redirect_to(users_path)
      end
    end

  end

end