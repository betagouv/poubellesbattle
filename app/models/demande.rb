class Demande < ApplicationRecord
  validates :first_name, :last_name, :email, :phone_number, :address, :logement_type, :inhabitant_type, presence: true
  validates_inclusion_of :potential_users, in: [true, false]
  has_one_attached :photo

  before_create :set_slug
  after_create :send_suivi_demande_email

  def to_param
    slug
  end

  private

  def set_slug
    loop do
      self.slug = SecureRandom.uuid
      break unless Demande.where(slug: slug).exists?
    end
  end

  def send_suivi_demande_email
    DemandeMailer.with(demande: self).suivi_demande.deliver_now
  end
end
