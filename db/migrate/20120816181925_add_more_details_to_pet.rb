class AddMoreDetailsToPet < ActiveRecord::Migration
  def change
    add_column :pets, :age, :integer
    add_column :pets, :age_period_id, :integer
    add_column :pets, :affection_id, :integer
    add_column :pets, :energy_level_id, :integer
    add_column :pets, :nature_id, :integer
    add_column :pets, :primary_color_id, :integer
    add_column :pets, :secondary_color_id, :integer
    add_column :pets, :fur_length_id, :integer
    add_column :pets, :primary_breed_id, :integer
    add_column :pets, :secondary_breed_id, :integer
    
    add_index :pets, :age_period_id
    add_index :pets, :affection_id
    add_index :pets, :energy_level_id
    add_index :pets, :nature_id
    add_index :pets, :primary_color_id
    add_index :pets, :secondary_color_id
    add_index :pets, :fur_length_id
    add_index :pets, :primary_breed_id
    add_index :pets, :secondary_breed_id
  end
end
