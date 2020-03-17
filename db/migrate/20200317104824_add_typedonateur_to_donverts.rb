class AddTypedonateurToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_column :donverts, :type_donateur, :string
  end
end
