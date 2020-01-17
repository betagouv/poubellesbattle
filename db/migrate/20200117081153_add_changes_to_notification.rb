class AddChangesToNotification < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :notification_type, :string
    add_column :notifications, :content, :string
  end
end
