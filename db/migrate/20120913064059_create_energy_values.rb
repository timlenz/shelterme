class CreateEnergyValues < ActiveRecord::Migration
  def change
    create_table :energy_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
