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
#  slug          :string(255)
#

class Shelter < ActiveRecord::Base
  attr_accessible :description, :email, :name, :phone, :precedence_id,
                  :rank, :street, :city, :state, :zipcode, :latitude, :longitude,
                  :sun_hours, :mon_hours, :tue_hours, :wed_hours, :thu_hours,
                  :fri_hours, :sat_hours, :slug
  
  belongs_to :precedence
  has_many :favorites, dependent: :destroy
  has_many :boosters, through: :favorites, source: :user
  has_many :pets, dependent: :destroy
  has_many :users
  has_many :journals
  
  validates :name, presence: true, 
                   length: { maximum: 60 },
                   uniqueness: { case_sensitive: false }
  validates :description, length: { maximum: 770 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :precedence_id, presence: true
  validates :street, presence: true, 
                     length: { maximum: 50 },
                     uniqueness: { case_sensitive: false }
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
  validates :slug, uniqueness: true, presence: true,
            exclusion: {in: %w[addphoto crop addvideo s newshelter findshelter listshelters mymanagedpets 
                              mmp p addpet newpet findpet potd join signin matchme signout u mysponsoredpets 
                              msp myfollowedpets mfp myupdates mu myfollowedusers mfu myphotos mp myvideos 
                              mv sa help about contact faq terms privacy statistics mobile]}
  
  geocoded_by :full_street_address
  
  before_validation :generate_slug, on: :create
  after_validation :geocode, if: lambda { :street_changed || :city_changed? || :state_changed? }
  
  profanity_filter :name, :description, :street, :city, :state, :zipcode, :sun_hours, :mon_hours, 
                   :tue_hours, :wed_hours, :thu_hours, :fri_hours, :sat_hours, :email
  
  def self.search(search)
    if search
      where('name iLIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.to_csv(pets)
    CSV.generate do |csv|
      csv << ["Notes", "ID", "Name", "Slug", "Status", "Added", "Updated", "Intake Date", "Days in Shelter", 
              "Sponsor", "Sponsor Email", "Rescue/Foster Name", "Contact Person", "Contact Email", "Contact Phone"]
      pets.each do |p|
        csv << ['', p.animal_code, p.name, p.slug, p.pet_state.status, p.created_at, p.updated_at, 
                p.intake_date, p.days_in_shelter, p.user.name, p.user.email, p.refuge_name, p.refuge_person, 
                p.refuge_email, p.refuge_phone]
      end
    end
  end
  
  def self.to_full_csv(pets)
    CSV.generate do |csv|
      csv << ["Notes", "ID", "Name", "Added", "Updated", "Sponsor", "Sponsor Email", "Size", "Gender",
              "Species", "Status", "Weight", "Current Age", "Age Group", "Affection", "Energy Level",
              "Nature", "Fur Length", "Primary Color", "Secondary Color", "Primary Breed",
              "Secondary Breed", "Intake Date", "Days in Shelter", "Rescue/Foster Name", "Contact Person",
              "Contact Email", "Contact Phone", "Description"]
      pets.each do |p|
        csv << ['', p.animal_code, p.name, p.created_at, p.updated_at, p.user.name, p.user.email,
                p.size.name, p.gender.sex, p.species.name, p.pet_state.status, p.weight, p.current_age.pluralize,
                p.age_group, p.affection.name, p.energy_level.level, p.nature.name, p.fur_length.length,
                p.primary_color.color, p.secondary_color ? p.secondary_color.color : '', p.primary_breed.name,
                p.secondary_breed ? p.secondary_breed.name : '', p.slug, p.intake_date, p.days_in_shelter, 
                p.refuge_name, p.refuge_person, p.refuge_email, p.refuge_phone, p.description]
      end
    end
  end
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug ||= name.parameterize.titleize.gsub(" ","")
    while Shelter.find{|s| s.slug == self.slug} do
      self.slug = self.slug + Random.rand(1..9).to_s
    end
  end
  
  def full_street_address
    [street, city, state].compact.join(', ')
  end
  
  def available_dogs_count
    pet_list = pets.where(species_id: 2, pet_state_id: [1,4]).where('pet_photos_count > 0').size # available & absent
  end
  
  def available_cats_count
    pet_list = pets.where(species_id: 1, pet_state_id: [1,4]).where('pet_photos_count > 0').size # available & absent
  end
  
  def available_dogs
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(species_id: 2, pet_state_id: [1,4]).where('pet_photos_count > 0') # available & absent
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
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(species_id: 1, pet_state_id: [1,4]).where('pet_photos_count > 0') # available & absent
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
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: 2).where('pet_photos_count > 0')
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
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: [1,4]).where('pet_photos_count > 0') # available & absent
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
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: 3).where('pet_photos_count > 0')
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
  
  def absent
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: 4).where('pet_photos_count > 0')
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
  
  def fostered
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: 5).where('pet_photos_count > 0')
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
  
  def rescued
    pet_list = pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(pet_state_id: 6).where('pet_photos_count > 0')
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
  
  def available_count
    pet_list = pets.where(pet_state_id: 1).where('pet_photos_count > 0').size
  end

  def adopted_count
    pet_list = pets.where(pet_state_id: 2).where('pet_photos_count > 0').size
  end
  
  def unavailable_count
    pet_list = pets.where(pet_state_id: 3).where('pet_photos_count > 0').size
  end
  
  def absent_count
    pet_list = pets.where(pet_state_id: 4).where('pet_photos_count > 0').size
  end
  
  def fostered_count
    pet_list = pets.where(pet_state_id: 5).where('pet_photos_count > 0').size
  end
  
  def rescued_count
    pet_list = pets.where(pet_state_id: 6).where('pet_photos_count > 0').size
  end
  
  def managers
    users = User.where(manager: true).where(shelter_id: self.id)
  end
  
  def managers_count
    users = User.where(manager: true).where(shelter_id: self.id).size
  end
  
  def available_journal
    newlist = journals.where(pet_state_id: 1).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 1).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end

  def absent_journal
    newlist = journals.where(pet_state_id: 4).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 4).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end

  def adopted_journal
    newlist = journals.where(pet_state_id: 2).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 2).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end
  
  def unavailable_journal
    newlist = journals.where(pet_state_id: 3).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 3).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end
  
  def fostered_journal
    newlist = journals.where(pet_state_id: 5).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 5).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end

  def rescued_journal
    newlist = journals.where(pet_state_id: 6).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    oldlist = journals.where(old_pet_state_id: 6).select{|s| s.created_at >= 7.days.ago.beginning_of_day}
    listed = []
    7.times do |n|
      listed[n] = newlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size - oldlist.select{|s| s.created_at >= (n+1).days.ago.beginning_of_day && s.created_at <= (n+1).days.ago.end_of_day}.size
    end
    7.times do |n|
      if n < 6
        listed[n] = listed[n] + listed[n+1]
      end
    end
    listed = listed.reverse.map{|j| j }.join ','
  end

  private
  
  def address_change
    
  end
  
  def sort_by
    self.precedence.rank
  end

end
