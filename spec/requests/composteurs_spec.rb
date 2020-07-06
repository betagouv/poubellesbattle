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
  describe "GET admin/composteurs/:id/edit" do
    it "redirects to root_path if not admin" do

    end
    it "renders show prefilled with composteur values when logged as admin" do
      sign_in create(:user, role: 2)
      get edit_admin_composteur_path(Composteur.last)

      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
      expect(response.body).to include("value=\"#{Composteur.last.address}\"")
    end
  end
  describe "PATCH admin/composteurs/:id" do
    it "redirects to root_path if not admin" do
      sign_in create(:user)
      patch admin_composteur_path(Composteur.last)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(root_path)
    end
    it "updates composteur and redirects to composteur_path" do
      sign_in create(:user, role: 2)
      previous_address = Composteur.last.address
      compost_hash = attributes_for(:composteur, id: Composteur.last.id)
      patch admin_composteur_path(Composteur.last, params: { composteur: compost_hash} )

      expect(Composteur.last.address).to_not eq(previous_address)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to(composteur_path(Composteur.last))
    end
  end
  describe "DESTROY admin/composteurs/:id" do
    it "redirects to sign_up if not logged and root_path if user not admin" do
      count_before = Composteur.count
      delete admin_composteur_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      sign_in create(:user)
      delete admin_composteur_path(Composteur.last)
      expect(response).to redirect_to(root_path)
      expect(Composteur.count).to eq(count_before)
    end
    it "destroy composteur if user admin" do
      count_before = Composteur.count
      sign_in create(:user, role: 2)
      delete admin_composteur_path(Composteur.last)
      expect(response).to redirect_to(admin_composteurs_path)
      expect(Composteur.count).to eq(count_before - 1)
    end
  end
  describe "Other non admin methods" do
    it "should redirect_to sign_up if not logged-in for all 6 non_admin non_crud methods" do
      post inscription_par_referent_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      post inscription_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      post referent_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      post validation_referent_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      post desinscription_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
      post non_referent_path(Composteur.last)
      expect(response).to redirect_to(new_user_session_path)
    end
    describe "inscription_par_referent" do
      it "add a new user and redirects to composteur_path" do
        dude = create(:user)
        sign_in create(:user, role: 1, composteur_id: Composteur.last.id)
        compo_user_before = Composteur.last.users.count
        post inscription_par_referent_path(Composteur.last, params: { user_id: dude.id })
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(Composteur.last.users.count).to eq(compo_user_before + 1)
      end
    end
    describe "inscription_composteur" do
      it "add the logged user and redirects to composteur_path" do
        sign_in create(:user)
        compo_user_before = Composteur.last.users.count
        post inscription_path(Composteur.last)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(Composteur.last.users.count).to eq(compo_user_before + 1)
      end
    end
    describe "referent_composteur" do
      it "on a site with no referent it creates a notification for admins and redirects to composteur_path" do
        sign_in create(:user)
        notifications_before = Notification.count
        post referent_path(Composteur.last)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(Notification.count).to eq(notifications_before + 1)
        expect(Notification.last.notification_type).to eq("demande-référent")
        expect(Notification.last.user_id).to eq(User.last.id)
      end
      it "on a site with at least one referent it creates a notification by email to first referent and redirects to composteur_path" do
        referent = create(:user, role: 1, composteur_id: Composteur.last.id)
        sign_in create(:user)
        notifications_before = Notification.count
        post referent_path(Composteur.last)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(Notification.count).to eq(notifications_before + 1)
        expect(Notification.last.notification_type).to eq("demande-référent-directe")
        expect(Notification.last.user_id).to eq(User.last.id)
      end
    end
    describe "validation_referent" do
      it "changes the role of a user as referent then redirect_to composteur" do
        john_doe = create(:user, composteur_id: Composteur.last.id)
        referent = create(:user, composteur_id: Composteur.last.id, role: 1)
        notification_ref = create(:notification, content: Composteur.last.id, notification_type: "demande-référent-directe", user_id: john_doe.id)
        notif_count = Notification.count
        sign_in create(:user, composteur_id: Composteur.last.id, role: 1)
        # this should actually be done differently, as i'm passing a notification to the method and not a composteur....
        post validation_referent_path(notification_ref)
        expect(response).to redirect_to(composteur_path(User.last.composteur_id))
        expect(Notification.count).to eq(notif_count - 1)
      end
    end
    describe "non_referent_composteur" do
      it "removes referent status from user" do
        sign_in create(:user, role: 1, composteur_id: Composteur.last)
        post non_referent_path(Composteur.last)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(User.last.referent?).to be false
        expect(User.last.compostophile?).to be true
      end
    end
    describe "desinscription_composteur" do
      it "removes all notifications, referent status, composteur_id and redirect_to composteur_path" do
        sign_in create(:user, role: 1, composteur_id: Composteur.last)
        depot = create(:notification, user_id: User.last)
        depot2 = create(:notification, user_id: User.last)
        depot3 = create(:notification, user_id: User.last)
        notifications_count = User.last.notifications.count
        post desinscription_path(Composteur.last)
        expect(User.last.referent?).to be false
        expect(User.last.composteur_id).to be nil
        expect(User.last.notifications).to be_empty
        expect(response).to redirect_to composteur_path(Composteur.last)
      end
    end
  end
  describe "Four Admin Methods" do
    it "redirects to root_path if user not admin" do
      sign_in create(:user)
      post admin_new_manual_latlng_path(Composteur.last)
      expect(response).to redirect_to(root_path)
      post admin_suppr_manual_latlng_path(Composteur.last)
      expect(response).to redirect_to(root_path)
      post admin_ajout_referent_path(Composteur.last)
      expect(response).to redirect_to(root_path)
      post admin_non_referent_path(Composteur.last)
      expect(response).to redirect_to(root_path)
    end
    describe "admin_new_manual_latlng" do
      it "adds new lat and lng to the composteur, redirect_to composteur_path" do
        sign_in create(:user, role: 2)
        expect(Composteur.last.manual_lat).to be nil
        post admin_new_manual_latlng_path(Composteur.last, params: { manual_lng: -0.3739579, manual_lat: 43.3044277 })
        expect(Composteur.last.manual_lat).to eq(43.3044277)
        expect(response).to redirect_to(edit_admin_composteur_path(Composteur.last))
      end
    end
    describe "admin_suppr_manual_latlng" do
      it "adds new lat and lng to the composteur, redirect_to composteur_path" do
        create(:composteur, manual_lng: -0.3739579, manual_lat: 43.3044277 )
        sign_in create(:user, role: 2)
        expect(Composteur.last.manual_lng).to eq(-0.3739579)
        post admin_suppr_manual_latlng_path(Composteur.last)
        expect(Composteur.last.manual_lat).to be nil
        expect(response).to redirect_to(edit_admin_composteur_path(Composteur.last))
      end
    end
    describe "admin_ajout_referent_composteur" do
      it "adds referent status from user" do
        joe = create(:user, composteur_id: Composteur.last.id)
        expect(joe.referent?).to be false
        sign_in create(:user, role: 2)
        post admin_ajout_referent_path(Composteur.last, params: { referent_id: joe.id })
        expect(response).to redirect_to(edit_admin_composteur_path(Composteur.last))
        expect(User.last(2).first.referent?).to be true
        expect(User.last(2).first.compostophile?).to be false
      end
    end
    describe "admin_non_referent_composteur" do
      it "removes referent status from user" do
        joe = create(:user, role: 1, composteur_id: Composteur.last.id)
        expect(joe.referent?).to be true
        sign_in create(:user, role: 2)
        post admin_non_referent_path(Composteur.last, params: { referent_id: joe.id })
        expect(response).to redirect_to(edit_admin_composteur_path(Composteur.last))
        expect(User.last(2).first.referent?).to be false
        expect(User.last(2).first.compostophile?).to be true
      end
    end
  end
  User.destroy_all
  Composteur.destroy_all
end
