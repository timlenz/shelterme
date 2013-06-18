class AddPetPhotosCountToPets < ActiveRecord::Migration
  def change
    add_column :pets, :pet_photos_count, :integer, default: 0, null: false
  end
end
