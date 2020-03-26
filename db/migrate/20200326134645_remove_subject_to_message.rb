class RemoveSubjectToMessage < ActiveRecord::Migration[5.2]
  def change
    remove_column :messages, :subject
  end
end
