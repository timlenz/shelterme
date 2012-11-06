# == Schema Information
#
# Table name: shelters
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  description   :text
#  email         :string(255)
#  phone         :string(255)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#  precedence_id :integer         default(1)
#  street        :string(255)
#  city          :string(255)
#  state         :string(255)
#  zipcode       :string(255)
#  latitude      :float
#  longitude     :float
#  sun_hours     :string(255)
#  mon_hours     :string(255)
#  tue_hours     :string(255)
#  wed_hours     :string(255)
#  thu_hours     :string(255)
#  fri_hours     :string(255)
#  sat_hours     :string(255)
#

class Shelter < ActiveRecord::Base
  attr_accessible :description, :email, :name, :phone, :precedence_id,
                  :rank, :street, :city, :state, :zipcode, :latitude, :longitude,
                  :sun_hours, :mon_hours, :tue_hours, :wed_hours, :thu_hours,
                  :fri_hours, :sat_hours
  
  belongs_to :precedence
  has_many :favorites, dependent: :destroy
  has_many :boosters, through: :favorites, source: :user
  has_many :pets, dependent: :destroy
  has_many :users
  
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }
  validates :phone, presence: true
  validates :precedence_id, presence: true
  validates :street, presence: true, length: { maximum: 50 }
  validates :city, presence: true
  validates :state, presence: true
  validates :zipcode, presence: true
  validates :sun_hours, presence: true
  validates :mon_hours, presence: true
  validates :tue_hours, presence: true
  validates :wed_hours, presence: true
  validates :thu_hours, presence: true
  validates :fri_hours, presence: true
  validates :sat_hours, presence: true
  
  geocoded_by :street
  after_validation :geocode, if: :street_changed? #Generalize to changes in any element of the Address
  
  profanity_filter :name, :description, :street, :city, :state, :zipcode, :sun_hours, :mon_hours, 
                   :tue_hours, :wed_hours, :thu_hours, :fri_hours, :sat_hours
  
  def self.search(search)
    if search
      where('name iLIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def available_dogs
    pet_list = pets.select{|p| p.species.name == 'dog' and p.pet_state.status == 'available'}
    if sort_by == "unpopular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }
    elsif sort_by == "popular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }.reverse
    elsif sort_by == "oldest"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }
    else
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }.reverse
    end
    return sorted_pet_list
  end
  
  def available_cats
    pet_list = pets.select{|p| p.species.name == 'cat' and p.pet_state.status == 'available'}
    if sort_by == "unpopular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }
    elsif sort_by == "popular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }.reverse
    elsif sort_by == "oldest"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }
    else
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }.reverse
    end
    return sorted_pet_list
  end
  
  def adopted
    pet_list = pets.select{|p| p.pet_state.status == 'adopted'}
    if sort_by == "unpopular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }
    elsif sort_by == "popular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }.reverse
    elsif sort_by == "oldest"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }
    else
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }.reverse
    end
    return sorted_pet_list
  end

  def available
    pet_list = pets.select{|p| p.pet_state.status == 'available'}
    if sort_by == "unpopular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }
    elsif sort_by == "popular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }.reverse
    elsif sort_by == "oldest"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }
    else
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }.reverse
    end
    return sorted_pet_list
  end
  
  def unavailable
    pet_list = pets.select{|p| p.pet_state.status == 'unavailable'}
    if sort_by == "unpopular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }
    elsif sort_by == "popular"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.bonds.size <=> p2.bonds.size }.reverse
    elsif sort_by == "oldest"
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }
    else
      sorted_pet_list = pet_list.sort{ |p1, p2| p1.created_at <=> p2.created_at }.reverse
    end
    return sorted_pet_list
  end

  private
  
  def sort_by
    self.precedence.rank
  end

end
