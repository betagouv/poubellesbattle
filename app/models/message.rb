class Message < ApplicationRecord
  belongs_to :donvert
  validates :content, :subject, :sender_email, :sender_full_name, presence: true

  # rajouter ici le after create send email to that dude
end
