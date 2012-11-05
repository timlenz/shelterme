class CreateMixes < ActiveRecord::Migration
  def change
    create_table :mixes do |t|
      t.integer :primary_breed_id
      t.integer :secondary_breed_id

      t.timestamps
    end
    
    add_index :mixes, :primary_breed_id
    add_index :mixes, :secondary_breed_id
    add_index :mixes, [:primary_breed_id, :secondary_breed_id], unique: true
  end
end
