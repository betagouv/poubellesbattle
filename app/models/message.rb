# == Schema Information
#
# Table name: messages
#
#  id               :bigint           not null, primary key
#  content          :string
#  sender_email     :string
#  sender_full_name :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  donvert_id       :bigint
#  message_type     :string
#  recipient_id     :bigint
#
class Message < ApplicationRecord
  belongs_to :donvert, optional: true
  validates :content, :sender_full_name, presence: true, length: { minimum: 4 }
  validates :sender_email, presence: true, format: { with: /\A[^@\s]+@[^@^.\s]+\.\w+\z/ }
  validates :message_type, inclusion: { in: ['interet-donvert', 'message-membres', 'message-agglo', 'message-to-referent'] }, presence: true

  # rajouter ici le after create send email to that dude
  after_create :send_interest_don_email, if: :message_type_is_interet_donvert?
  after_create :send_message_to_members_email, if: :message_type_is_message_membres?
  after_create :send_message_to_agglo_email, if: :message_type_is_message_agglo?
  after_create :send_message_to_referent_email, if: :message_type_is_message_to_referent?

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

  def send_message_to_referent_email
    MessageMailer.with(message: self).message_to_referent.deliver_now
  end

  def message_type_is_message_to_referent?
    self.message_type == 'message-to-referent'
  end
end
