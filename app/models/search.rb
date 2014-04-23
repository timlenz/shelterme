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
#  user_id         :integer
#  save_search     :boolean         default(FALSE)
#  search_string   :string(255)
#

class Search < ActiveRecord::Base
  attr_accessible :affection_id, :age_group, :breed_id, :energy_level_id,
                  :gender_id, :location, :nature_id, :size_id, :species_id, :breed_name,
                  :user_id, :save, :search_string
  
  belongs_to :breed
  
  def pets
    @pets ||= find_pets
  end
  
  def se_str(distance)  # search string by name or animal_code
    nearbys = shelters(distance) 
    if nearbys and search_string.present? # make sure to not return any pets without names
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where('name iLIKE :search OR animal_code iLIKE :search', {search: search_string})
      # unless pets.size > 0 and pets.first.animal_code.downcase == search_string.downcase
      #   pets = pets.where(pet_state_id: [1,4]) # only show available pets unless search by ID
      # end
      pets = pets.where('pet_photos_count > 0')
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end    
  end
  
  def sp_ag_si_ge_en_af_na(distance) # species, age group, size, gender, energy level, affection and nature    
    nearbys = shelters(distance) 
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(size_id: size_id).where(gender_id: gender_id)
      pets = pets.where(energy_level_id: energy_level_id).where(affection_id: affection_id).where(nature_id: nature_id)
      pets = pets.select{|p| p.age_group == age_group}
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def sp_ag_si_ge(distance)  # species, age group, size and gender
    nearbys = shelters(distance) 
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(size_id: size_id).where(gender_id: gender_id)
      pets = pets.select{|p| p.age_group == age_group}
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end   
  end
  
  def sp_ag_si(distance)  # species, age group and size
    nearbys = shelters(distance) 
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(size_id: size_id)
      pets = pets.select{|p| p.age_group == age_group}
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end   
  end
  
  def sp_ag_ge(distance)  # species, age group and gender
    nearbys = shelters(distance) 
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(gender_id: gender_id)
      pets = pets.select{|p| p.age_group == age_group}
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end   
  end
  
  def sp_si_ge(distance)  # species, size and gender
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(size_id: size_id).where(gender_id: gender_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def sp_en_af_na(distance) # species, energy level, affection and nature
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(energy_level_id: energy_level_id).where(affection_id: affection_id).where(nature_id: nature_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def sp_en_af(distance) # species, energy level and affection
    nearbys = shelters(distance)  
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(energy_level_id: energy_level_id).where(affection_id: affection_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end  
  end
  
  def sp_en_na(distance) # species, energy level and nature
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(energy_level_id: energy_level_id).where(nature_id: nature_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end

  def sp_af_na(distance) # species, affection and nature
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where(affection_id: affection_id).where(nature_id: nature_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def sp_br(distance) # species and breed
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.where('(primary_breed_id = ?) OR (secondary_breed_id = ?)', breed_id, breed_id)
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def sp(distance) # species
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(species_id: species_id)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def pe(distance) # any pets, regardless of parameters
    nearbys = shelters(distance)    
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      pets = pets.where(pet_state_id: [1,4])  # available and absent pet states
      pets = pets.where('pet_photos_count > 0')
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    else
      pets = []
    end
  end
  
  def breed_name
    breed.try(:name)
  end

  def breed_name=(name)
    self.breed = Breed.find_by_name(name) if name.present?
  end
  
private

  def shelters(radius)
    nearbys = Shelter.near(location, radius, order: "distance").map{|s| s.id} if location.present?
  end

  def find_pets
    # added ", US" as hack around Geonames location conflation issues
    nearbys = Shelter.near(location + ", US", 50, order: "distance").map{|s| s.id} if location.present?
    if nearbys
      pets = Pet.where('shelter_id in (?)', nearbys)
      # use "%#{search_string}%" to search for partial match
      pets = pets.where('name iLIKE :search OR animal_code iLIKE :search', {search: search_string}) if search_string.present?
      pets = pets.where(species_id: species_id) if species_id.present?
      pets = pets.where('(primary_breed_id = ?) OR (secondary_breed_id = ?)', breed_id, breed_id) if breed_id.present?
      pets = pets.where(gender_id: gender_id) if gender_id.present?
      pets = pets.where(size_id: size_id) if size_id.present?
      pets = pets.where(energy_level_id: energy_level_id) if energy_level_id.present?
      pets = pets.where(affection_id: affection_id) if affection_id.present?
      pets = pets.where(nature_id: nature_id) if nature_id.present?
      # if pets.size > 0  # only show available pets unless search by ID
      #   unless search_string.present? and pets.first.animal_code.downcase == search_string.downcase
      #     pets = pets.where(pet_state_id: [1,4])
      #   end
      # end
      pets = pets.where(pet_state_id: [1,4]) unless search_string.present?
      pets = pets.where('pet_photos_count > 0')
      pets = pets.select{|p| p.age_group == age_group} if age_group.present?
      pets = pets.sort_by {|s| nearbys.index(s.send(:shelter_id))} if location.present?
    else
      pets = []
    end
  end
end
