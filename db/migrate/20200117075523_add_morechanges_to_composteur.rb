class AddMorechangesToComposteur < ActiveRecord::Migration[5.2]
  def change
    remove_column :composteurs, :bacs_number
    remove_column :composteurs, :photo
    remove_column :composteurs, :referent_email
    remove_column :composteurs, :referent_full_name
    remove_column :composteurs, :publicorprivate
  end
end
