class AddManualgeocodeToComposteur < ActiveRecord::Migration[5.2]
  def change
    add_column :composteurs, :manual_lat, :float
    add_column :composteurs, :manual_lng, :float
  end
end
