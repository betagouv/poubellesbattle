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
#  composteur_id     :bigint
#  resolved          :boolean          default(FALSE)
#
class Notification < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :composteur, optional: true

  validates :content, presence: true
  validates :notification_type, inclusion: { in: ['signaler-contenu', 'demande-référent', 'demande-référent-directe', 'depot', 'depot direct', 'anomalie', 'message', 'message-admin'] }, presence: true

  after_save :send_demande_referent_directe_email, if: :demande_directe?
  # after_create :send_signaler_contenu_email, if: :signaler_contenu?

  private

  def demande_directe?
    self.notification_type == "demande-référent-directe"
  end

  def send_demande_referent_directe_email
    NotificationMailer.with(notification: self).demande_referent_directe.deliver_now
  end

  # def signaler_contenu?
  #   self.notification_type == 'signaler-contenu'
  # end

  # def send_signaler_contenu_email
  #   NotificationMailer.with(notification: self).signaler_contenu.deliver_now
  # end
end
