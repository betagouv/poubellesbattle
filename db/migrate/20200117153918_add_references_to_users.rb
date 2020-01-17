class AddReferencesToUsers < ActiveRecord::Migration[5.2]
  def change
    remove_reference :users, :composteur, foreign_key: true
    add_reference :users, :composteur, null: true, foreign_key: true
  end
end
