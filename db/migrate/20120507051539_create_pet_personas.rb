class CreatePetPersonas < ActiveRecord::Migration
  def change
    create_table :pet_personas do |t|
      t.integer :affection_id
      t.integer :energy_level_id
      t.integer :nature_id

      t.timestamps
    end
    
    add_index :pet_personas, :affection_id
    add_index :pet_personas, :energy_level_id
    add_index :pet_personas, :nature_id
  end
end
