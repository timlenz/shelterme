class AddDetailsToPet < ActiveRecord::Migration
  def change
    add_column :pets, :mix_id, :integer
    add_column :pets, :age_id, :integer
    add_column :pets, :size_id, :integer
    add_column :pets, :pet_persona_id, :integer
    add_column :pets, :coat_id, :integer
    add_column :pets, :gender_id, :integer
    add_column :pets, :species_id, :integer
    add_column :pets, :pet_state_id, :integer
    
    add_column :pets, :weight, :integer
    
    add_index :pets, :mix_id
    add_index :pets, :age_id
    add_index :pets, :size_id
    add_index :pets, :pet_persona_id
    add_index :pets, :coat_id
    add_index :pets, :gender_id
    add_index :pets, :species_id
    add_index :pets, :pet_state_id
  end
end
