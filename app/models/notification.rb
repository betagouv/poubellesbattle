class Notification < ApplicationRecord
  belongs_to :user
  # delegate :composteur, to: :user
end
