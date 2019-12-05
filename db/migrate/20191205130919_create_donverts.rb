class CreateDonverts < ActiveRecord::Migration[5.2]
  def change
    create_table :donverts do |t|
      t.string :title
      t.string :type_matiere_orga
      t.string :description
      t.float :volume_litres
      t.string :donneur_name
      t.string :donneur_address
      t.string :donneur_tel
      t.string :donneur_email
      t.date :date_fin_dispo

      t.timestamps
    end
  end
end
