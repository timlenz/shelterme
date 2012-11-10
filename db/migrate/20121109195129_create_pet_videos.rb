class CreatePetVideos < ActiveRecord::Migration
  def change
    create_table :pet_videos do |t|
      t.integer :pet_id
      t.string :panda_video_id
      t.boolean :primary, default: false

      t.timestamps
    end
  end
end
