class NotificationMailerPreview < ActionMailer::Preview
  def demande_referent_directe
    notification = Notification.last

    NotificationMailer.with(notification: notification).demande_referent_directe
  end

  def signaler_contenu
    notification = Notification.last

    NotificationMailer.with(notification: notification).signaler_contenu
  end

  def signaler_contenu_to_user
    notification = Notification.last

    NotificationMailer.with(notification: notification).signaler_contenu_to_user
  end

  def demande_referent_state
    notification = Notification.last

    NotificationMailer.with(notification: notification, state: "validée").demande_referent_state
  end
end
