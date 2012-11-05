class CreateOpenValues < ActiveRecord::Migration
  def change
    create_table :open_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
