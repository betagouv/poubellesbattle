class Message < ApplicationRecord
  belongs_to :donvert, optional: true
  validates :content, :sender_email, :sender_full_name, :message_type, presence: true

  # rajouter ici le after create send email to that dude
  after_create :send_interest_don_email, if: :message_type_is_interet_donvert?
  after_create :send_message_to_members_email, if: :message_type_is_message_membres?
  after_create :send_message_to_agglo_email, if: :message_type_is_message_agglo?

  private

  def send_interest_don_email
    MessageMailer.with(message: self).interest_don.deliver_now
  end

  def message_type_is_interet_donvert?
    self.message_type == 'interet-donvert'
  end

  def send_message_to_members_email
    MessageMailer.with(message: self).message_to_members.deliver_now
  end

  def message_type_is_message_membres?
    self.message_type == 'message-membres'
  end

  def send_message_to_agglo_email
    MessageMailer.with(message: self).message_to_agglo.deliver_now
  end

  def message_type_is_message_agglo?
    self.message_type == 'message-agglo'
  end
end
