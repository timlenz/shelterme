class AddSlugToPets < ActiveRecord::Migration
  def change
    add_column :pets, :slug, :string
    add_index :pets, :slug
  end
end
