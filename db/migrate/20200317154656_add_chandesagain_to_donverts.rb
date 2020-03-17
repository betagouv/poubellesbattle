class AddChandesagainToDonverts < ActiveRecord::Migration[5.2]
  def change
    remove_column :donverts, :type_donateur
    add_column :donverts, :donateur_type, :string
  end
end
