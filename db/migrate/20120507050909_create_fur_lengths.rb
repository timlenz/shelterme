class CreateFurLengths < ActiveRecord::Migration
  def change
    create_table :fur_lengths do |t|
      t.string :length

      t.timestamps
    end
  end
end
