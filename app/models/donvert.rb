# == Schema Information
#
# Table name: donverts
#
#  id                :bigint           not null, primary key
#  title             :string
#  type_matiere_orga :string
#  description       :string
#  volume_litres     :float
#  donneur_name      :string
#  donneur_address   :string
#  donneur_tel       :string
#  donneur_email     :string
#  date_fin_dispo    :date
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  slug              :string           not null
#  pourvu            :boolean          default(FALSE)
#  donateur_type     :string
#  user_id           :bigint
#  codeword          :string
#  archived          :boolean          default(FALSE)
#
class Donvert < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  validates :description, presence: true, length: { within: 10..350 }
  validates :donateur_type, presence: true, inclusion: { in: ["site de compostage", "entreprise du paysage", "association", "établissement scolaire", "particulier", "autre"] }
  validates :type_matiere_orga, presence: true, inclusion: { in: ["compost", "structurant", "outils", "graines", "plantes", "autre"] }
  validates :donneur_name, presence: true, length: { in: 2..25 }
  validates :donneur_address, length: { minimum: 5 }, presence: true
  validates :donneur_email, presence: true, format: { with: /\A[^@\s]+@[^@^.\s]+\.\w+\z/ }
  validates :donneur_tel, presence: true, format: { with: /\A(0|\+33)[^0^8^9](\d{8})\z/ }

  validate :date_fin_dispo_cannot_be_in_the_past, on: :create

  has_one_attached :photo
  belongs_to :user, optional: true
  has_many :messages

  before_create :set_slug
  before_create :set_codeword

  after_create :send_confirmation_don_email

  def to_param
    slug
  end

  def date_fin_dispo_cannot_be_in_the_past
    if date_fin_dispo.present? && date_fin_dispo < Date.today
      errors.add(:date_fin_dispo, "can't be in the past")
    end
  end

  private

  def set_slug
    loop do
      self.slug = SecureRandom.uuid
      break unless Donvert.where(slug: slug).exists?
    end
  end

  def set_codeword
    self.codeword = SecureRandom.alphanumeric
  end

  def send_confirmation_don_email
    DonvertMailer.with(donvert: self).confirmation_don.deliver_now
  end
end
