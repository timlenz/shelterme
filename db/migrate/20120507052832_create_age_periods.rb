class CreateAgePeriods < ActiveRecord::Migration
  def change
    create_table :age_periods do |t|
      t.string :length

      t.timestamps
    end
  end
end
