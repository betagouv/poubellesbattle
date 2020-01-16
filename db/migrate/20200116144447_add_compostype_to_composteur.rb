class AddCompostypeToComposteur < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :composteur_type, :string
    remove_column :composteurs, :type
  end
end
