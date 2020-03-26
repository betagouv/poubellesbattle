class AddDonvertToMessages < ActiveRecord::Migration[5.2]
  def change
    add_reference :messages, :donvert, null: true, foreign_key: true
  end
end
