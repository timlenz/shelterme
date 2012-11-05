class CreateFurColors < ActiveRecord::Migration
  def change
    create_table :fur_colors do |t|
      t.string :color

      t.timestamps
    end
  end
end
