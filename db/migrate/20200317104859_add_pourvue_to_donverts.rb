class AddPourvueToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_column :donverts, :pourvue, :boolean, default: false
  end
end
