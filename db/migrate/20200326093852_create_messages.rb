class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.string :subject
      t.string :content
      t.string :sender_email
      t.string :sender_full_name

      t.timestamps
    end
  end
end
