class ChangeRoleToAccess < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :role, :access
  end
end
