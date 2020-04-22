class AddNewsletterToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ok_newsletter, :boolean, default: false
  end
end
