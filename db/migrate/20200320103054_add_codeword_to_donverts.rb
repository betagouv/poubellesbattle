class AddCodewordToDonverts < ActiveRecord::Migration[5.2]
  def change
    add_column :donverts, :codeword, :string
  end
end
