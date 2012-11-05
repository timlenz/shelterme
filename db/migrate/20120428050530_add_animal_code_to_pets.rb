class AddAnimalCodeToPets < ActiveRecord::Migration
  def change
    add_column :pets, :animal_code, :string
    add_index :pets, :animal_code, unique: true
  end
end
