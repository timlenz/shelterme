class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.integer :species_id
      t.string :age_group
      t.integer :gender_id
      t.integer :breed_id
      t.integer :size_id
      t.integer :energy_level_id
      t.integer :affection_id
      t.integer :nature_id
      t.string :location

      t.timestamps
    end
  end
end
