class AddComposteuridToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :composteur, null: true
  end
end
