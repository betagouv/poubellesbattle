class AddingfieldtoCompo < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :volume, :string
    add_column :composteurs, :publicorprivate, :string
  end
end
