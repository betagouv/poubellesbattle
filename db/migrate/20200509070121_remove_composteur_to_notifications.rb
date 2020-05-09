class RemoveComposteurToNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notifications, :composteur
  end
end
