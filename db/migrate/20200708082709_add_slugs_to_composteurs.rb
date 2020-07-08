class AddSlugsToComposteurs < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :slug, :string
  end
end
