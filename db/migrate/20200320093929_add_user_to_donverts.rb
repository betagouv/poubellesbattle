class AddUserToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_reference :donverts, :user, null: true, foreign_key: true
  end
end
