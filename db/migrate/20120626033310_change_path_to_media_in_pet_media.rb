class ChangePathToMediaInPetMedia < ActiveRecord::Migration
  def up
    change_table :pet_media do |t|
      t.rename :path, :media
    end
  end

  def down
    change_table :pet_media do |t|
      t.rename :media, :path
    end
  end
end
