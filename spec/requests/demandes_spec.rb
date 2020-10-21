require 'rails_helper'

RSpec.describe "Demandes", type: :request do
  describe "CRUD for demandes" do
    before {
      5.times { create(:demande) }
    }
    it "works" do
      expect(Demande.count).to eq(5)
    end
    describe "Admin only CRUD should redirect" do
      it "redirects to sign_up or root path if not logged or not admin" do
        get admin_demandes_path
        expect(response).to redirect_to(new_user_session_path)
        get edit_admin_demande_path(Demande.last)
        expect(response).to redirect_to(new_user_session_path)
        patch admin_demande_path(Demande.last)
        expect(response).to redirect_to(new_user_session_path)
        delete admin_demande_path(Demande.last)
        expect(response).to redirect_to(new_user_session_path)
        sign_in create(:user)
        get admin_demandes_path
        expect(response).to redirect_to(root_path)
        expect(response).to have_http_status(302)
        get edit_admin_demande_path(Demande.last)
        expect(response).to redirect_to(root_path)
        patch admin_demande_path(Demande.last)
        expect(response).to redirect_to(root_path)
        delete admin_demande_path(Demande.last)
        expect(response).to redirect_to(root_path)
      end
    end
    describe "GET admin/demandes" do
      it "shows a list of demandes with infos if user admin" do
        sign_in create(:user, role: 2)
        get admin_demandes_path
        expect(response.body).to include(Demande.first.address)
        expect(response.body).to include("href=\"mailto:#{Demande.last.email}")
      end
    end
    describe "GET /demandes/suivre/:slug  'suivre' method -> not 'show'" do
      it "returns a page with infos on the demande and a sign_up form if not logged" do
        get suivre_path(Demande.last)
        expect(response.body).to include("<p>Elle est en cours de traitement par nos agents.</p>")
        # no more sign-up in DEMO
        # expect(response.body).to include("<form class=\"simple_form new_user\"")
      end
      it "shows more info if user is logged with same email" do
        sign_in create(:user, first_name: Demande.last.first_name, email: Demande.last.email)
        get suivre_path(Demande.last)
        expect(response.body).to include(User.last.first_name)
      end
    end
    describe "GET /demandes/new" do
      it "renders :new template" do
        get new_demande_path
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
      end
    end
    describe "POST /demandes" do
      it "creates a new demande and redirects to suivre_path" do
        demandes_count_before = Demande.count
        demande_hash = attributes_for(:demande)
        post demandes_path, params: { demande: demande_hash }
        expect(response).to redirect_to(suivre_path(Demande.last))
        expect(response).to have_http_status(302)
        expect(Demande.count).to eq(demandes_count_before + 1)
      end
    end
    describe "GET admin/demandes/:slug/edit" do
      it "renders :edit template" do
        sign_in create(:user, role: 2)
        get edit_admin_demande_path(Demande.last)
        expect(response).to have_http_status(200)
        expect(response).to render_template(:edit)
      end
    end
    describe "PATCH admin/demandes/:slug" do
      it "updates the demande and redirects to edit" do
        sign_in create(:user, role: 2)
        demande_previous_address = Demande.last.address
        demande_hash = attributes_for(:demande, slug: Demande.last.slug)
        patch admin_demande_path(Demande.last, params: { demande: demande_hash })
        expect(response).to redirect_to(edit_admin_demande_path(Demande.last))
        expect(Demande.last.address).to_not eq(demande_previous_address)
      end
    end
    describe "DELETE admin/demandes/:slug" do
      it "destroys demande and redirects to admin/demandes" do
        sign_in create(:user, role: 2)
        demandes_count_before = Demande.count
        delete admin_demande_path(Demande.last)
        expect(Demande.count).to eq(demandes_count_before - 1)
        expect(response).to redirect_to(admin_demandes_path)
      end
    end
  end
  describe "formulaire_toggle" do
    it "toggles and redirects to admin edit path" do
      sign_in create(:user, role: 2)
      create(:demande)
      expect(Demande.last.completed_form).to be false
      post admin_formulaire_toggle_path(Demande.last)
      expect(Demande.last.completed_form).to be true
      expect(response).to redirect_to(edit_admin_demande_path(Demande.last))
      post admin_formulaire_toggle_path(Demande.last)
      expect(Demande.last.completed_form).to be false
      expect(response).to redirect_to(edit_admin_demande_path(Demande.last))
    end
  end
end
