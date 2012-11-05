class CreatePrecedences < ActiveRecord::Migration
  def change
    create_table :precedences do |t|
      t.string :rank

      t.timestamps
    end
  end
end
