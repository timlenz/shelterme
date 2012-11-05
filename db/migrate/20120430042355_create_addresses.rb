class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.integer :shelter_id

      t.timestamps
    end
    
    add_index :addresses, :shelter_id
  end
end
