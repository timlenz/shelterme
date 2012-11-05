class CreateCleanValues < ActiveRecord::Migration
  def change
    create_table :clean_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
