class CreateEnergyLevels < ActiveRecord::Migration
  def change
    create_table :energy_levels do |t|
      t.string :level

      t.timestamps
    end
  end
end
