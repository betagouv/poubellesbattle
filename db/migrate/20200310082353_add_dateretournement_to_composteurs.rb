class AddDateretournementToComposteurs < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :date_retournement, :date
  end
end
