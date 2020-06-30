require 'rails_helper'

RSpec.describe "Composteurs", type: :request do
  before {
          first_composteur = create(:composteur)
          second_composteur = create(:composteur)
          compostophile = create(:user, role: 0, composteur_id: first_composteur.id)
          referent = create(:user, role: 1, composteur_id: first_composteur.id)
         }

  describe "GET /composteurs" do
    it "returns the home page with 2 composteurs and the map" do
      get composteurs_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Découvrez les 2  composteurs collectifs")
    end
  end

  describe "GET /composteurs/id" do
    it "returns composteur view with sign_up form if not logged" do
      get composteur_path(Composteur.last.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("<h3>S'inscrire sur Poubelles Battle</h3>")
    end
    it "returns composteur view with messagerie if logged in and on user's composteur" do
      sign_in create(:user, composteur_id: Composteur.last.id)
      get composteur_path(Composteur.last.id)

      expect(response).to have_http_status(200)
      expect(response.body).to include("Messagerie")
    end
    it "returns composteur view with reduce access : no messagerie if logged in and not on user's composteur" do
      sign_in create(:user, composteur_id: Composteur.first.id)
      get composteur_path(Composteur.last.id)

      expect(response).to have_http_status(200)
      expect(response.body).to_not include("Messagerie")
    end
  end

  describe "GET admin/composteurs/new" do
    it "redirects to root_path if not admin" do
      sign_in create(:user)
      get new_admin_composteur_path

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end
    it "renders new composteur form if user is admin" do
      sign_in create(:user, role: 2)
      get new_admin_composteur_path

      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST admin/composteurs" do
    it "redirects to root_path and does not create a new compost if not admin" do
      composteur_count_before = Composteur.count
      sign_in create(:user)
      post admin_composteurs_path, params: attributes_for(:composteur)
      composteur_count_after = Composteur.count

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
      expect(composteur_count_before).to eq(composteur_count_after)
    end
    it "creates a new composteur and redirect to compost list if user is admin" do
      composteur_count_before = Composteur.count
      sign_in create(:user, role: 2)
      compost_hash = attributes_for(:composteur)
      post admin_composteurs_path, params: { composteur: compost_hash }
      composteur_count_after = Composteur.count

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(admin_composteurs_path(Composteur.last.id))
      expect(composteur_count_after).to eq(composteur_count_before + 1)
    end
  end
  User.destroy_all
  Composteur.destroy_all
end