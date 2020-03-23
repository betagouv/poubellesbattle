class Notification < ApplicationRecord
  belongs_to :user
  # delegate :composteur, to: :user
  validates :content, :notification_type, presence: true

  after_save :send_demande_referent_directe_email, if: :demande_directe?

  private

  def demande_directe?
    self.notification_type == "demande-référent-directe"
  end

  def send_demande_referent_directe_email
    NotificationMailer.with(notification: self).demande_referent_directe.deliver_now
  end
end
