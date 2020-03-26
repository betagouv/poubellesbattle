class Donvert < ApplicationRecord
  validates :donateur_type, :title, :type_matiere_orga, :description, :date_fin_dispo, :donneur_email, :donneur_tel, :donneur_name, :donneur_address, presence: true
  has_one_attached :photo
  belongs_to :user, optional: true
  has_many :messages

  before_create :set_slug
  before_create :set_codeword

  after_create :send_confirmation_don_email

  def to_param
    slug
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
