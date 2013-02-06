class DropPetColumns < ActiveRecord::Migration
  def up
    remove_index "pets", :column => "mix_id"
    remove_index "pets", :column => "age_id"
    remove_index "pets", :column => "coat_id"
    remove_index "pets", :column => "pet_persona_id"
    remove_column :pets, :mix_id
    remove_column :pets, :age_id
    remove_column :pets, :coat_id
    remove_column :pets, :pet_persona_id
  end

  def down
    add_column :pets, :pet_persona_id, :integer
    add_column :pets, :coat_id, :integer
    add_column :pets, :age_id, :integer
    add_column :pets, :mix_id, :integer
    add_index :pets, :pet_persona_id
    add_index :pets, :coat_id
    add_index :pets, :age_id
    add_index :pets, :mix_id
  end
end
