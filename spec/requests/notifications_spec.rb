require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "CRUD for notifications" do
    before {
      5.times { create(:notification) }
    }
    it "works" do
      expect(Notification.count).to eq(5)
    end
    describe "Admin only CRUD should redirect" do
      it "redirects to sign_up or root path if not logged or not admin" do
        get admin_notifications_path
        expect(response).to redirect_to(new_user_session_path)
        post admin_notifications_path
        expect(response).to redirect_to(new_user_session_path)
        delete admin_notification_path(Notification.last)
        expect(response).to redirect_to(new_user_session_path)
        sign_in create(:user)
        get admin_notifications_path
        expect(response).to redirect_to(root_path)
        post admin_notifications_path
        expect(response).to redirect_to(root_path)
        delete admin_notification_path(Notification.last)
        expect(response).to redirect_to(root_path)
      end
    end
    describe "GET admin/notifications" do
      it "shows the list of all notification from admin to composteurs and a form for a new notification if user admin" do
        create(:notification, notification_type: "message-admin")
        create(:notification, notification_type: "message-admin")
        sign_in create(:user, role: 2)
        get admin_notifications_path
        expect(response.body).to include("<div class=\"notif-content\">#{Notification.last.content}</div")
        expect(response.body).to include("<form class=\"simple_form new_notification\"")
        expect(response.body).to include("value=\"message-admin\" type=\"hidden\"")
      end
    end
    describe "POST admin/notifications" do
      it "creates a new notification and redirects to admin_notifications_path" do
        notifications_count_before = Notification.count
        notification_hash = attributes_for(:notification, notification_type: "message-admin")
        sign_in create(:user, role: 2)
        post admin_notifications_path, params: { notification: notification_hash }
        expect(response).to redirect_to(admin_notifications_path)
        expect(response).to have_http_status(302)
        expect(Notification.count).to eq(notifications_count_before + 1)
      end
    end
    describe "DELETE admin/notifications/:id" do
      it "destroys notification and redirects to the right controller" do
        create(:composteur)
        create(:user, composteur_id: Composteur.last.id, role: 1)
        sign_in create(:user, role: 2)

        # notification linked to a composteur
        create(:notification, composteur_id: Composteur.last.id)
        notifications_count_before = Notification.count

        delete admin_notification_path(Notification.last)
        expect(Notification.count).to eq(notifications_count_before - 1)
        expect(response).to redirect_to(composteur_path(Composteur.last))

        # notification linked to a user itself linked to a composteur
        create(:user, composteur_id: Composteur.last.id)
        create(:notification, user_id: User.last.id)

        delete admin_notification_path(Notification.last)
        expect(Notification.count).to eq(notifications_count_before - 1)
        expect(response).to redirect_to(composteur_path(Composteur.last))

        # if notification is a 'message-admin' redirects to admin_notifications_path
        create(:notification, notification_type: "message-admin")

        delete admin_notification_path(Notification.last)
        expect(Notification.count).to eq(notifications_count_before - 1)
        expect(response).to redirect_to(admin_notifications_path)

        # if notification is a 'demande-référent' redirects to admin_demandes_path
        create(:notification, notification_type: "demande-référent", content: Composteur.last.id, user_id: User.last.id)

        delete admin_notification_path(Notification.last)
        expect(Notification.count).to eq(notifications_count_before - 1)
        expect(response).to redirect_to(admin_demandes_path)

        # NON ADMIN DESTROY FOR REFERENT ONLY ON DEMANDE REFERENT DIRECTE
        # if notification is a 'demande-référent-directe' redirects to composteur_path
        create(:notification, notification_type: "demande-référent-directe", content: Composteur.last.id, user_id: User.last.id)

        delete notification_path(Notification.last)
        expect(Notification.count).to eq(notifications_count_before - 1)
        expect(response).to redirect_to(composteur_path(Composteur.last))
      end
    end
    describe "POST /notifications" do
      it "redirects if not logged // creates a new notification then redirect_to composteur_path" do
        notifications_count_before = Notification.count
        post notifications_path
        expect(response).to redirect_to(new_user_session_path)
        create(:composteur)
        sign_in create(:user, composteur_id: Composteur.last.id)
        notification_hash = attributes_for(:notification)
        # gets the user_id of current_user
        post notifications_path, params: { notification: notification_hash }
        expect(Notification.count).to eq(notifications_count_before + 1)
        expect(response).to redirect_to(composteur_path(Composteur.last))
      end
    end
    describe "GET /anonymous_depot" do
      it "creates a new dépot notification and redirects to composteur_path" do
        notifications_count_before = Notification.count
        create(:composteur)
        get anonymous_depot_path, params: { slug: Composteur.last.slug, type: "depot" }
        expect(Notification.count).to eq(notifications_count_before + 1)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response.body).to include("#{Composteur.last.name}")
        expect(response.body).to include("<form class=\"simple_form new_user\"")
        # same but with user signed_in
        sign_in create(:user, composteur_id: Composteur.last.id)
        get anonymous_depot_path, params: { slug: Composteur.last.slug, type: "depot" }
        expect(Notification.count).to eq(notifications_count_before + 2)
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(response).to have_http_status(302)
        follow_redirect!
        expect(response.body).to include("Nouveau dépot masqué 🦸 sur #{Composteur.last.name} !")
      end
    end
    describe "POST /resolved" do
      it "changes notification.resolved to true" do
        create(:composteur)
        create(:composteur)
        create(:user, composteur_id: Composteur.last.id)
        create(:notification, user_id: User.last.id, composteur_id: Composteur.last.id, notification_type: "anomalie")

        post resolved_path(Notification.last)
        follow_redirect!
        expect(Notification.last.resolved).to be false

        # sign up a referent from another site
        sign_in create(:user, role: 1, composteur_id: Composteur.first.id)
        post resolved_path(Notification.last)
        expect(Notification.last.resolved).to be false

        # sign up referent from same site should work
        sign_in create(:user, role: 1, composteur_id: Composteur.last.id)
        post resolved_path(Notification.last)
        expect(Notification.last.resolved).to be true
      end
    end
  end
end
