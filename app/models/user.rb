# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#  phone_number           :string
#  role                   :string
#  composteur_id          :bigint
#  ok_phone               :boolean
#  ok_mail                :boolean
#  ok_newsletter          :boolean          default(FALSE)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :composteur, optional: true
  has_many :notifications, dependent: :destroy
  has_many :donverts
  has_one_attached :photo

  enum role: [:compostophile, :referent, :admin]

  include PgSearch::Model
  pg_search_scope :search_by_first_name_and_last_name,
    against: [:first_name, :last_name, :role],
    # associated_against: {
    #   composteur: [ :name ]
    # },
    using: {
      tsearch: { prefix: true }
    }

  after_create :send_welcome_email

  def self.to_csv
    attributes = %w{id email first_name last_name role}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
      end
    end
  end

  def self.to_csv_newsletter
    attributes = %w{id email first_name last_name role}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        if user.ok_newsletter
          csv << user.attributes.values_at(*attributes)
        end
      end
    end
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end
end
