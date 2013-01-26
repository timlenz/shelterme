class RemoveAnimalCodeIndex < ActiveRecord::Migration
  def up
    remove_index :pets, :animal_code
  end

  def down
    add_index :pets, :animal_code, unique: true
  end
end
