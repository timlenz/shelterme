class CreateShelters < ActiveRecord::Migration
  def change
    create_table :shelters do |t|
      t.string :name
      t.string :description
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
