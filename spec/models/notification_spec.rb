require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:new_site) { Composteur.create!(name: "Hédas", address: "2 rue du hédas, Pau", category: "composteur de quartier", public: true) }
  let(:new_referent) { User.new(email: "jean.test@email.com", password: "123456", first_name:"not so", last_name:"okok", role: 1) }
  let(:new_user_1) { User.new(email: "player1@email.com", password: "123456", first_name:"not so", last_name:"okok", role: 0) }
  before { new_referent.composteur = new_site }
  before { new_user_1.composteur = new_site }
  before { new_referent.save }
  before { new_user_1.save }
  subject { Notification.new(content: "en voilà une bonne nouvelle", notification_type: "message") }
  before { subject.save }

  it 'should be a valid example' do
    is_expected.to be_valid
  end

  it 'should only accept valid notification_type' do
    subject.notification_type = nil
    is_expected.to_not be_valid
    subject.notification_type = "my type"
    is_expected.to_not be_valid
  end

  it "can't have no content" do
    subject.content = nil
    is_expected.to_not be_valid
  end

  it 'is valid with a user attached to it or a composteur site attached' do
    subject.user = new_referent
    is_expected.to be_valid
    subject.composteur = new_site
    is_expected.to be_valid
    subject.user = nil
    is_expected.to be_valid
  end

  # removed mailers for DEMO version
  # describe 'when demande-référent-directe' do
  #   it 'should send an email on demande to become a référent' do
  #     subject.content = new_site.id
  #     subject.user_id = new_user_1.id
  #     subject.notification_type = 'demande-référent-directe'
  #     expect { subject.instance_eval { send_demande_referent_directe_email } }.to change {ActionMailer::Base.deliveries.count}.by(1)
  #     expect(ActionMailer::Base.deliveries.last.to.first).to eq(new_referent.email)
  #   end
  # end
end
