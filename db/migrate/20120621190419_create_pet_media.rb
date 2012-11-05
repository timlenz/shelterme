class CreatePetMedia < ActiveRecord::Migration
  def change
    create_table :pet_media do |t|
      t.integer :pet_id
      t.string :path
      t.boolean :photo
      t.boolean :primary

      t.timestamps
    end
    
    add_index :pet_media, :pet_id
  end
end
