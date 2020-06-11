RSpec.describe DemandeMailer, type: :mailer do
  describe 'new_demande' do
    let(:demande) { Demande.create(first_name: 'jean', last_name: 'test',
                        email: 'jean.test@email.com', phone_number: '0123456789',
                        address: '2 rue du hédas, Pau', logement_type: 'maison',
                        inhabitant_type: 'locataire', potential_users: true)}
    let(:demande_mail) { described_class.new_demande(demande).deliver_now }

    it 'renders the subject' do
      expect(demande_mail.subject).to eq('Votre demande de site de compostage')
    end
  end
end
