class AddRecipientemailToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :recipient_email, :string
  end
end
