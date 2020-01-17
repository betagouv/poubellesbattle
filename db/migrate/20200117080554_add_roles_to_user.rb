class AddRolesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :role, :string
    remove_column :users, :referent
  end
end
