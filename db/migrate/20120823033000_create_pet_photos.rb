class CreatePetPhotos < ActiveRecord::Migration
  def change
    create_table :pet_photos do |t|
      t.integer :pet_id
      t.string :image

      t.timestamps
    end
    
    add_index :pet_photos, :pet_id
  end
end
