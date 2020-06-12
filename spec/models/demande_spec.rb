require 'rails_helper'

RSpec.describe Demande, type: :model do
  subject { Demande.new(first_name: 'jean', last_name: 'test',
                        email: 'jean.test@email.com', phone_number: '0123456789',
                        address: '2 rue du hédas, Pau', logement_type: 'maison',
                        inhabitant_type: 'locataire', potential_users: true) }

  before { subject.save }

  it 'should set a slug' do
    expect(subject.slug).to_not be_nil
  end

  it 'should have a first_name' do
    subject.first_name = nil
    is_expected.to_not be_valid
  end

  it 'should have a last_name' do
    subject.last_name = nil
    is_expected.to_not be_valid
  end

  it 'should have an email' do
    subject.email = nil
    is_expected.to_not be_valid
  end

  it 'should have a valid email' do
    subject.email = "jean.test@email.."
    is_expected.to_not be_valid
  end

  it 'should have a phone_number' do
    subject.phone_number = nil
    is_expected.to_not be_valid
  end

  it 'should have a valid phone_number' do
    subject.phone_number = "1023654789548"
    is_expected.to_not be_valid
  end

  it 'should accept both 0 and +33 phone_numbers' do
    subject.phone_number = "+33123456789"
    is_expected.to be_valid
  end

  it 'should have an address' do
    subject.address = nil
    is_expected.to_not be_valid
  end

  it 'should have a logement_type' do
    subject.logement_type = nil
    is_expected.to_not be_valid
  end

  it 'should have a inhabitant_type' do
    subject.inhabitant_type = nil
    is_expected.to_not be_valid
  end

  it 'should have a potential_users' do
    subject.potential_users = nil
    is_expected.to_not be_valid
  end

  it 'sends an email after create' do
    # instance_eval is here because i'm calling a private method
    expect { subject.instance_eval { send_new_demande_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    # checking the first to in the last email generated
    expect(ActionMailer::Base.deliveries.last.to.first).to eq(subject.email)
    # checking the subject of the last email generated
    expect(ActionMailer::Base.deliveries.last.subject).to eq('Votre demande de site de compostage')
  end

  it 'sends a refusal email if demande status is refusee' do
    subject.status = 'refusée'
    subject.save
    expect { subject.instance_eval { send_refus_demande_email } }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(ActionMailer::Base.deliveries.last.subject).to eq('Refus de votre demande de site de compostage')
  end

  it 'sends a planification email if demande is planifiée and planification_date is not nil' do
    subject.status = 'planifiée'
    subject.planification_date = Date.today + 3.weeks
    subject.save
    expect { subject.instance_eval { send_planification_demande_email} }.to change { ActionMailer::Base.deliveries.count }.by(1)
    expect(ActionMailer::Base.deliveries.last.subject).to eq("Planification de l'installation du nouveau site de compostage")
    #checks if the date is actualy readable in the email
    expect(ActionMailer::Base.deliveries.last.body).to be_include((Date.today + 3.weeks).strftime("%d/%m"))
  end
end
