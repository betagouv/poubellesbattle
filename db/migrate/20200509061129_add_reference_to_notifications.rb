class AddReferenceToNotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :composteur_id
    add_reference :notifications, :composteur, null: true
  end
end
