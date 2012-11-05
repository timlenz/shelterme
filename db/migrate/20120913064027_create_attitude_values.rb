class CreateAttitudeValues < ActiveRecord::Migration
  def change
    create_table :attitude_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
