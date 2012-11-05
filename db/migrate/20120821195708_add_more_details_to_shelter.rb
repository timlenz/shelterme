class AddMoreDetailsToShelter < ActiveRecord::Migration
  def change
    add_column :shelters, :street, :string
    add_column :shelters, :city, :string
    add_column :shelters, :state, :string
    add_column :shelters, :zipcode, :string
    add_column :shelters, :latitude, :float
    add_column :shelters, :longitude, :float
    add_column :shelters, :sun_hours, :string
    add_column :shelters, :mon_hours, :string
    add_column :shelters, :tue_hours, :string
    add_column :shelters, :wed_hours, :string
    add_column :shelters, :thu_hours, :string
    add_column :shelters, :fri_hours, :string
    add_column :shelters, :sat_hours, :string
  end
end
