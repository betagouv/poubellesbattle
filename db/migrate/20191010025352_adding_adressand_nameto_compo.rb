class AddingAdressandNametoCompo < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :address, :string
    add_column :composteurs, :name, :string
  end
end
