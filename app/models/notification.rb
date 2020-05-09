# == Schema Information
#
# Table name: notifications
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  notification_type :string
#  content           :string
#  user_id           :bigint
#  resolved          :boolean          default(FALSE)
#
class Notification < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :composteur, optional: true

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
