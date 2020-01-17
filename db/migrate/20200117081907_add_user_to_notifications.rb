class AddUserToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :user, foreign_key: true
  end
end
