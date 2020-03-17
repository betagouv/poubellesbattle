class AddSlugToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_column :donverts, :slug, :string, null: false
    add_index :donverts, :slug, unique: true
  end
end
