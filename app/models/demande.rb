class Demande < ApplicationRecord
  validates :first_name, :last_name, :email, :phone_number, :address, :logement_type, :inhabitant_type, presence: true
  validates_inclusion_of :potential_users, in: [true, false]
  has_one_attached :photo

  before_create :set_slug
  after_create :send_new_demande_email
  after_update :send_refus_demande_email, if: :demande_refusee?
  after_update :send_planification_demande_email, if: :demande_planifiee?

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

  def send_new_demande_email
    DemandeMailer.with(demande: self).new_demande.deliver_now
  end

  def demande_refusee?
    self.status == "refusée"
  end

  def send_refus_demande_email
    DemandeMailer.with(demande: self).refus_demande.deliver_now
  end

  def demande_planifiee?
    self.status == "planifiée" && self.planification_date != nil
  end

  def send_planification_demande_email
    DemandeMailer.with(demande: self).planification_demande.deliver_now
  end
end
