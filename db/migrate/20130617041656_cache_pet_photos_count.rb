class CachePetPhotosCount < ActiveRecord::Migration
  def up
    execute "update pets set pet_photos_count=(select count(*) from pet_photos where pet_id=pets.id)"
  end

  def down
  end
end
