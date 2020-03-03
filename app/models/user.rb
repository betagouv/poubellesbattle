class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :composteur, optional: true
  has_many :notifications
  has_one_attached :photo

  include PgSearch::Model
  pg_search_scope :search_by_first_name_and_last_name,
    against: [ :first_name, :last_name ],
    # associated_against: {
    #   composteur: [ :name ]
    # },
    using: {
      tsearch: { prefix: true }
    }
end
