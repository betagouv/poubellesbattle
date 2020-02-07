class Demande < ApplicationRecord
  validates :first_name, :last_name, :email, :phone_number, :address, :logement_type, :inhabitant_type, presence: true
  validates_inclusion_of :potential_users, in: [true, false]
  has_one_attached :photo

  before_create :generate_random_id

  private

  def generate_random_id
    self.id = SecureRandom.uuid
  end
end
