class AddMessagetypeToMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :message_type, :string
  end
end
