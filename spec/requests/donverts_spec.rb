require 'rails_helper'

RSpec.describe "Donverts", type: :request do
  describe "CRUD for donverts" do
    before {
      5.times { create(:donvert) }
    }
    it "works" do
      expect(Donvert.count).to eq(5)
    end
    describe "GET /bourse_verte aka donverts_path" do
      it "renders all available donverts" do
        get donverts_path
        expect(response).to have_http_status(200)
        expect(response.body).to include(Donvert.last.donneur_name)
      end
    end
    describe "GET mes_dons_path" do
      it "renders all donverts offers from the logged user" do
        sign_in create(:user)
        2.times { create(:donvert, donneur_name: User.last.first_name, user_id: User.last.id) }
        get mes_dons_path
        expect(response.body).to include(User.last.first_name)
      end
    end
    describe "GET bourse_verte/:slug" do
      it "renders the view of one donvert if user signed_in created the donvert" do
        create(:donvert)
        get donvert_path(Donvert.last)
        expect(response).to redirect_to(new_user_session_path)
        sign_in create(:user)
        get donvert_path(Donvert.last)
        expect(response).to redirect_to(donverts_path)
        sign_in create(:user)
        create(:donvert, user_id: User.last.id)
        get donvert_path(Donvert.last)
        expect(response.body).to include("<h2>Aperçu de mon don</h2>")
        expect(response).to render_template(:show)
      end
    end
    describe "GET bourse_verte/:slug/link" do
      it "links the donvert to a user if codeword is valid" do
        sign_in create(:user)
        get link_path(Donvert.last)
        expect(response).to redirect_to(donverts_path)
        get link_path(Donvert.last, codeword: Donvert.first.codeword)
        expect(response).to redirect_to(donverts_path)
        get link_path(Donvert.last, codeword: Donvert.last.codeword)
        expect(response).to redirect_to(donvert_path(Donvert.last))
      end
    end
    describe "GET bourse_verte/new" do
      it "renders :new template with form for new donvert" do
        get new_donvert_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("<form class=\"simple_form new_donvert\"")
      end
    end
    describe "POST bourse_verte" do
      it "creates a new donvert and link it to current_user if user signed_in" do
        donvert_before = Donvert.count
        donvert_hash = attributes_for(:donvert)
        post donverts_path, params: { donvert: donvert_hash }
        expect(response).to redirect_to(donverts_path)
        sign_in create(:user)
        new_hash = attributes_for(:donvert)
        post donverts_path, params: { donvert: new_hash }
        expect(response).to redirect_to(donverts_path)
        expect(Donvert.count).to eq(donvert_before + 2)
      end
    end
    describe "POST bourse_verte/:slug/pourvu" do
      it "changes donvert.pourvu to true" do
        sign_in create(:user)
        create(:donvert)
        post pourvu_path(Donvert.last)
        expect(Donvert.last.pourvu).to be false
        expect(response).to redirect_to(donverts_path)

        sign_in create(:user)
        create(:donvert, user_id: User.last.id)
        post pourvu_path(Donvert.last)
        expect(Donvert.last.pourvu).to be true
        expect(response).to redirect_to(donverts_path)
      end
    end
    describe "POST bourse_verte/:slug/archive" do
      it "changes donvert.archived to true" do
        sign_in create(:user)
        create(:donvert)
        post archive_path(Donvert.last)
        expect(Donvert.last.archived).to be false
        expect(response).to redirect_to(donverts_path)

        sign_in create(:user)
        create(:donvert, user_id: User.last.id)
        post archive_path(Donvert.last)
        expect(Donvert.last.archived).to be true
        expect(response).to redirect_to(donverts_path)
      end
    end
    describe "DELETE admin/bourse_verte/:slug" do
      it "destroy a donvert only if admin logged" do
        donvert_before = Donvert.count
        delete admin_donvert_path(Donvert.last)
        expect(response).to redirect_to(new_user_session_path)
        expect(Donvert.count).to eq(donvert_before)
        sign_in create(:user)
        delete admin_donvert_path(Donvert.last)
        expect(response).to redirect_to(root_path)
        expect(Donvert.count).to eq(donvert_before)
        sign_in create(:user, role: 2)
        delete admin_donvert_path(Donvert.last)
        expect(response).to redirect_to(donverts_path)
        expect(Donvert.count).to eq(donvert_before - 1)
      end
    end
  end
end
