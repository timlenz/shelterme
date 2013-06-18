class CacheBondsCount < ActiveRecord::Migration
  def up
    execute "update pets set bonds_count=(select count(*) from bonds where pet_id=pets.id)"
  end

  def down
  end
end
