# == Schema Information
#
# Table name: searches
#
#  id              :integer         not null, primary key
#  species_id      :integer
#  age_group       :string(255)
#  gender_id       :integer
#  breed_id        :integer
#  size_id         :integer
#  energy_level_id :integer
#  affection_id    :integer
#  nature_id       :integer
#  location        :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Search < ActiveRecord::Base
  attr_accessible :affection_id, :age_group, :breed_id, :energy_level_id,
                  :gender_id, :location, :nature_id, :size_id, :species_id, :breed_name
  
  belongs_to :breed
  
  def pets
    @pets ||= find_pets
  end
  
  def near_species
    nearbys = Shelter.near(location, 200, order: "distance").map{|s| s.id}
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys)
    pets = pets.where(species_id: species_id)
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    nearest = pets.map{|p| p.shelter_id }.first
    pets = pets.select{|p| p.shelter_id == nearest}
  end
  
  def near_sb
    nearbys = Shelter.near(location, 200, order: "distance").map{|s| s.id}
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys)
    pets = pets.where(species_id: species_id)
    pets = pets.where('(primary_breed_id = ?) OR (secondary_breed_id = ?)', breed_id, breed_id)
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    nearest = pets.map{|p| p.shelter_id }.first
    pets = pets.select{|p| p.shelter_id == nearest}
  end
  
  def far_species
    nearbys = Shelter.near(location, 1000, order: "distance").map{|s| s.id}
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys)
    pets = pets.where(species_id: species_id)
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    nearest = pets.map{|p| p.shelter_id }.first
    pets = pets.select{|p| p.shelter_id == nearest}
  end
  
  def far_sb
    nearbys = Shelter.near(location, 1000, order: "distance").map{|s| s.id}
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys)
    pets = pets.where(species_id: species_id)
    pets = pets.where('(primary_breed_id = ?) OR (secondary_breed_id = ?)', breed_id, breed_id)
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    nearest = pets.map{|p| p.shelter_id }.first
    pets = pets.select{|p| p.shelter_id == nearest}
  end
  
  def local_species
    nearbys = Shelter.near(location, 50, order: "distance").map{|s| s.id}
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys)
    pets = pets.where(species_id: species_id)
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
  end
  
  def breed_name
    breed.try(:name)
  end

  def breed_name=(name)
    self.breed = Breed.find_by_name(name) if name.present?
  end
  
private
  def find_pets
    nearbys = Shelter.near(location, 50, order: "distance").map{|s| s.id} if location.present?
    pets = Pet.order(:name)
    pets = pets.where('shelter_id in (?)', nearbys) if location.present?
    pets = pets.where(species_id: species_id) if species_id.present?
    pets = pets.where(gender_id: gender_id) if gender_id.present?
    pets = pets.where(size_id: size_id) if size_id.present?
    pets = pets.where(energy_level_id: energy_level_id) if energy_level_id.present?
    pets = pets.where(affection_id: affection_id) if affection_id.present?
    pets = pets.where(nature_id: nature_id) if nature_id.present?
    pets = pets.where('(primary_breed_id = ?) OR (secondary_breed_id = ?)', breed_id, breed_id) if breed_id.present?
    pets = pets.select{|p| p.age_group == age_group} if age_group.present?
    pets = pets.select{|p| p.pet_state.status == "available"}
    pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))} if location.present?
  end
end
