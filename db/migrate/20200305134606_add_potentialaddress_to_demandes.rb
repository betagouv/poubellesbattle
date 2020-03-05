class AddPotentialaddressToDemandes < ActiveRecord::Migration[5.2]
  def change
    add_column :demandes, :potential_address, :string
    add_column :demandes, :notes_to_collegues, :string
  end
end
