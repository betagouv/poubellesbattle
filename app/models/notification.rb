class Notification < ApplicationRecord
  belongs_to :user
  # delegate :composteur, to: :user
  validates :content, :notification_type, presence: true
end
