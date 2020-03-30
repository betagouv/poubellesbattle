class AddMorechangesToMessages < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :recipient_email
    add_column :messages, :recipient_id, :bigint
  end
end
