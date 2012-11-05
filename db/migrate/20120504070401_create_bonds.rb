class CreateBonds < ActiveRecord::Migration
  def change
    create_table :bonds do |t|
      t.integer :user_id
      t.integer :pet_id

      t.timestamps
    end
    
    add_index :bonds, :user_id
    add_index :bonds, :pet_id
    add_index :bonds, [:user_id, :pet_id], unique: true
  end
end
