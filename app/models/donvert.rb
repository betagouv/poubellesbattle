class Donvert < ApplicationRecord
  validates :type_donateur, :title, :type_matiere_orga, :description, :date_fin_dispo, :donneur_email, :donneur_tel, :donneur_name, :donneur_address, presence: true
  has_one_attached :photo

  before_create :set_slug

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
end
