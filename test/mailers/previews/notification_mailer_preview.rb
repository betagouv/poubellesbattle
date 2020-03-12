class NotificationMailerPreview < ActionMailer::Preview
  def demande_referent_directe
    notification = Notification.last

    NotificationMailer.with(notification: notification).demande_referent_directe
  end
end
