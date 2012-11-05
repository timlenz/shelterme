class CreateEmotionValues < ActiveRecord::Migration
  def change
    create_table :emotion_values do |t|
      t.string :name

      t.timestamps
    end
  end
end
