class AddSlugToDemandes < ActiveRecord::Migration[5.2]
  def change
    add_column :demandes, :slug, :string, null: false
    add_index :demandes, :slug, unique: true
  end
end
