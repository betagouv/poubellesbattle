require 'rails_helper'

RSpec.describe "Messages", type: :request do
  describe "CRUD for messages" do
    before {
      5.times {
        create(:user)
        create(:message, recipient_id: User.last.id)
      }
    }
    it "works" do
      expect(Message.count).to eq(5)
    end
    describe "POST messages_path" do
      it "creates a new message and redirects to right controller" do
        message_count = Message.count
        message_hash = attributes_for(:message, recipient_id: User.last.id)
        post messages_path, params: { message: message_hash }
        expect(response).to redirect_to(new_user_session_path)
        sign_in create(:user)
        post messages_path, params: { message: message_hash }
        expect(Message.count).to eq(message_count + 1)
        create(:donvert)
        interet_hash = attributes_for(:message, message_type: "interet-donvert", recipient_id: User.last.id, donvert_id: Donvert.last.id)
        post messages_path, params: { message: interet_hash }
        expect(response).to redirect_to(donverts_path)
        expect(Message.count).to eq(message_count + 2)
        create(:composteur)
        3.times { create(:user, composteur_id: Composteur.last.id) }
        create(:user, role: 1, composteur_id: Composteur.last.id)
        # sign_in user that is not referent redirects to root_path
        sign_in create(:user, composteur_id: Composteur.last.id)
        message_membre_hash = attributes_for(:message, message_type: "message-membres", sender_email: User.last.email)
        post messages_path, params: { message: message_membre_hash }
        expect(response).to redirect_to(root_path)
        # shouldn't create a message if user is not referent
        expect(Message.count).to eq(message_count + 2)
        # sign_in referent user redirects to composteur after creating a new message
        sign_in create(:user, role: 1, composteur_id: Composteur.last.id)
        message_membre_hash = attributes_for(:message, message_type: "message-membres", sender_email: User.last.email)
        post messages_path, params: { message: message_membre_hash }
        expect(response).to redirect_to(composteur_path(Composteur.last))
        expect(Message.count).to eq(message_count + 3)
      end
    end
  end
end
