class CreateShelterHours < ActiveRecord::Migration
  def change
    create_table :shelter_hours do |t|
      t.integer :shelter_id
      t.integer :day, limit: 1
      t.time :open_time
      t.time :close_time

      t.timestamps
    end
  end
end
