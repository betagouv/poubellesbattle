# == Schema Information
#
# Table name: composteurs
#
#  id                :bigint           not null, primary key
#  latitude          :float
#  longitude         :float
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  address           :string
#  name              :string
#  category          :string
#  public            :boolean
#  installation_date :date
#  status            :string
#  volume            :string
#  residence_name    :string
#  commentaire       :string
#  participants      :integer
#  composteur_type   :string
#  date_retournement :date
#  manual_lat        :float
#  manual_lng        :float
#
class Composteur < ApplicationRecord
  include PgSearch::Model
  pg_search_scope :search_by_name_and_address,
                  against: [:name, :address], using: { tsearch: { prefix: true } }
  validates :name, presence: true, length: { in: 2..25 }
  validates :address, length: { minimum: 5 }, presence: true, uniqueness: true
  validates :category, inclusion: { in: ["composteur bas d'immeuble", "composteur de quartier"] }
  validates :public, inclusion: { in: [true, false], message: "Merci de cocher une des deux cases"}

  has_many :users
  has_many :notifications, through: :users
  has_many :donverts, through: :users
  has_one_attached :photo

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  after_validation :set_slug, on: :create

  def to_param
    slug
  end

  private

  def set_slug
    self.slug = self.name.to_s.parameterize
  end
end
