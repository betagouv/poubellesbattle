class AddArchivedToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_column :donverts, :archived, :boolean, default: false
  end
end
