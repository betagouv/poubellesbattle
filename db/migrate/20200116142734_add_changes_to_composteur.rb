class AddChangesToComposteur < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :type, :string
    add_column :composteurs, :residence_name, :string
    add_column :composteurs, :commentaire, :string
    add_column :composteurs, :participants, :integer
  end
end
