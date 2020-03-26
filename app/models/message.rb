class Message < ApplicationRecord
  belongs_to :donvert
  validates :content, :sender_email, :sender_full_name, presence: true

  # rajouter ici le after create send email to that dude
  after_create :send_interest_don_email

  private

  def send_interest_don_email
    MessageMailer.with(message: self).interest_don.deliver_now
  end
end
