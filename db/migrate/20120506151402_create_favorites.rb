class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :shelter_id

      t.timestamps
    end

      add_index :favorites, :user_id
      add_index :favorites, :shelter_id
      add_index :favorites, [:user_id, :shelter_id], unique: true
  end
end
