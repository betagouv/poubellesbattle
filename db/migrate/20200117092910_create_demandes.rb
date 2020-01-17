class CreateDemandes < ActiveRecord::Migration[5.2]
  def change
    create_table :demandes do |t|
      t.string :status
      t.string :logement_type
      t.string :inhabitant_type
      t.string :address
      t.boolean :location_found
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.boolean :potential_users
      t.boolean :completed_form
      t.date :planification_date

      t.timestamps
    end
  end
end
