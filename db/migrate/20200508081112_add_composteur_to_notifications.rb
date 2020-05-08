class AddComposteurToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :composteur_id, :integer
  end
end
