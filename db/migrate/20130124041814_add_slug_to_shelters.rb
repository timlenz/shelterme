class AddSlugToShelters < ActiveRecord::Migration
  def change
    add_column :shelters, :slug, :string
    add_index :shelters, :slug
  end
end
