class ChangeCompletedToDemandes < ActiveRecord::Migration[5.2]
  def change
    change_column_default :demandes, :completed_form, from: nil, to: false
  end
end
