class AddAnimalCodeShelterIndexToPets < ActiveRecord::Migration
  def change
    add_index :pets, [:animal_code, :shelter_id], unique: true
  end
end
