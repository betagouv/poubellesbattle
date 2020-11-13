require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:new_site) { Composteur.create!(name: "Hédas", address: "2 rue du hédas, Pau", category: "composteur de quartier", public: true) }
  let(:new_referent) { User.new(email: "jean.test@email.com", password: "123456", first_name:"not so", last_name:"okok", role: 1) }
  let(:new_user_1) { User.new(email: "player1@email.com", password: "123456", first_name:"not so", last_name:"okok", role: 0) }
  let(:new_user_2) { User.new(email: "player2@email.com", password: "123456", first_name:"not so", last_name:"okok", role: 0) }
  before { new_referent.composteur = new_site }
  before { new_user_1.composteur = new_site }
  before { new_user_2.composteur = new_site }
  before { new_referent.save }
  before { new_user_1.save }
  before { new_user_2.save }

  let(:new_don) { Donvert.create!(title: 'compost', description: "c'est du compost c'est le mien 123456",
                      donateur_type: "particulier", type_matiere_orga: 'compost',
                      donneur_name: 'jp', donneur_address: "4 rue du hédas, Pau",
                      donneur_email: 'okok@email.com', donneur_tel: '0123456789',
                      date_fin_dispo: Date.today + 3.weeks) }
  subject { Message.new(content: "je suis très heureux de vous écrire ce mail",
                        sender_email: "jean.test@email.com",
                        sender_full_name: "jean josé du domaine battle",
                        message_type: 'interet-donvert') }

  before { subject.donvert = new_don }

  before { subject.save }

  it 'should be a valid example' do
    is_expected.to be_valid
  end

  it 'should not accept nil email' do
    subject.sender_email = nil
    is_expected.to_not be_valid
  end

  it 'should only accept valid email' do
    subject.sender_email = "jean@rien"
    is_expected.to_not be_valid
  end

  it 'should only accept message_type from the list' do
    subject.message_type = 'my own kind'
    is_expected.to_not be_valid
  end

  # removed mailers for DEMO version
  # it 'should generate a valid email interet-donvert to donneur_email' do
  #   expect { subject.instance_eval { send_interest_don_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #   expect(ActionMailer::Base.deliveries.last.subject).to eq("Votre proposition de don attire l'attention !")
  #   expect(ActionMailer::Base.deliveries.last.to.first).to eq(new_don.donneur_email)
  # end

  # it 'should should display the right infos' do
  #   expect(ActionMailer::Base.deliveries.last.body).to be_include(subject.sender_email)
  #   # same line but different
  #   # expect(ActionMailer::Base.deliveries.last.body).to include {subject.sender_email}
  #   expect(ActionMailer::Base.deliveries.last.body).to be_include(subject.content)
  # end

  # describe 'with a message-membres' do
  #   before { subject.message_type = "message-membres" }
  #   before { subject.save }

  #   it 'should generate a valid email message_to_members to members of this site' do
  #     expect { subject.instance_eval { send_message_to_members_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #     expect(ActionMailer::Base.deliveries.last.subject).to eq("Message de #{new_referent.first_name.capitalize} pour les membres de #{new_referent.composteur.name}")
  #     expect(ActionMailer::Base.deliveries.last.bcc.count).to eq(new_site.users.count)
  #   end
  # end

  # describe 'with a message-agglo' do
  #   before { subject.message_type = "message-agglo" }
  #   before { subject.save }

  #   it 'should generate a valid email message_to_agglo to agglo email' do
  #     expect { subject.instance_eval { send_message_to_agglo_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #     expect(ActionMailer::Base.deliveries.last.subject).to eq("Message de #{new_referent.first_name.capitalize} - référent•e du site #{new_referent.composteur.name}")
  #   end
  # end

  # describe 'with a message-to-referent' do
  #   before { subject.recipient_id = new_referent.id }
  #   before { subject.message_type = "message-to-referent" }
  #   before { subject.save }

  #   it 'should generate a valid email message_to_referent to referent of this site' do
  #     expect { subject.instance_eval { send_message_to_referent_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
  #     expect(ActionMailer::Base.deliveries.last.subject).to eq("#{new_referent.first_name} : #{subject.sender_full_name} vient de vous écrire.")
  #     expect(ActionMailer::Base.deliveries.last.to.first).to eq(new_referent.email)
  #   end
  # end
end
