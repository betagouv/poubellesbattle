class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :composteur, optional: true
  has_many :notifications, dependent: :destroy
  has_many :donverts
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

  after_create :send_welcome_email

  def self.to_csv
    attributes = %w{id email first_name last_name}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
      end
    end
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
