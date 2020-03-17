class AddChangesToDonverts < ActiveRecord::Migration[5.2]
  def change
    remove_column :donverts, :pourvue, :boolean, default: false
    add_column :donverts, :pourvu, :boolean, default: false
  end
end
