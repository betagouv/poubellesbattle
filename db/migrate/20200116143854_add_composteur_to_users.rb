class AddComposteurToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :composteur, foreign_key: true
  end
end
