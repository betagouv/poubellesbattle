class AddingfieldsonComposteurMigration < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :category, :string
    add_column :composteurs, :public, :boolean
    add_column :composteurs, :bacs_number, :integer
    add_column :composteurs, :photo, :string
    add_column :composteurs, :referent_email, :string
    add_column :composteurs, :referent_full_name, :string
    add_column :composteurs, :installation_date, :date
    add_column :composteurs, :status, :string
  end
end
