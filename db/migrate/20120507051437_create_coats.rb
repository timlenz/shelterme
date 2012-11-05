class CreateCoats < ActiveRecord::Migration
  def change
    create_table :coats do |t|
      t.integer :fur_color_id
      t.integer :fur_length_id

      t.timestamps
    end
    
    add_index :coats, :fur_color_id
    add_index :coats, :fur_length_id
    add_index :coats, [:fur_color_id, :fur_length_id], unique: true
  end
end
