class AddContactinfoToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ok_phone, :boolean
    add_column :users, :ok_mail, :boolean
  end
end
