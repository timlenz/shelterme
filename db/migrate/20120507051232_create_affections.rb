class CreateAffections < ActiveRecord::Migration
  def change
    create_table :affections do |t|
      t.string :name

      t.timestamps
    end
  end
end
