class DropPetColumns < ActiveRecord::Migration
  def up
    remove_index "pets", :column => "mix_id"
    remove_index "pets", :column => "age_id"
    remove_column :pets, :mix_id
    remove_column :pets, :age_id
  end

  def down
    add_column :pets, :age_id, :integer
    add_column :pets, :mix_id, :integer
    add_index :pets, :age_id
    add_index :pets, :mix_id
  end
end
