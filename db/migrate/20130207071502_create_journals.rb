class CreateJournals < ActiveRecord::Migration
  def change
    create_table :journals do |t|
      t.integer :shelter_id
      t.integer :pet_id
      t.integer :pet_state_id

      t.timestamps
    end

    add_index :journals, :shelter_id
    add_index :journals, :pet_id
    add_index :journals, :pet_state_id
  end
end
