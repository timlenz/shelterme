# == Schema Information
#
# Table name: pets
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  description        :text
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  user_id            :integer
#  animal_code        :string(255)
#  size_id            :integer
#  gender_id          :integer
#  species_id         :integer
#  pet_state_id       :integer
#  weight             :integer
#  shelter_id         :integer
#  age                :float
#  age_period_id      :integer
#  affection_id       :integer
#  energy_level_id    :integer
#  nature_id          :integer
#  primary_color_id   :integer
#  secondary_color_id :integer
#  fur_length_id      :integer
#  primary_breed_id   :integer
#  secondary_breed_id :integer
#  slug               :string(255)
#

class Pet < ActiveRecord::Base
  attr_accessible :name, :description, :animal_code, :weight, :size_id, 
                  :gender_id, :species_id, :pet_state_id, :shelter_id,
                  :age, :age_period_id, :affection_id,
                  :energy_level_id, :nature_id, :primary_color_id,
                  :secondary_color_id, :fur_length_id, :primary_breed_id,
                  :secondary_breed_id, :shelter,
                  :shelter_attributes, :species_attributes, :gender_attributes,
                  :size_attributes, :age_period_attributes, 
                  :affection_attributes, :energy_level_attributes, :fur_length_attributes,
                  :nature_attributes, :breed_attributes, :shelter_name,
                  :primary_breed_name, :secondary_breed_name, :user_id
  belongs_to :user
  belongs_to :shelter
  belongs_to :size
  belongs_to :shelter
  belongs_to :gender
  belongs_to :species
  belongs_to :pet_state
  belongs_to :age_period
  belongs_to :affection
  belongs_to :energy_level
  belongs_to :nature
  belongs_to :fur_length
  belongs_to :breed
  belongs_to :primary_color, class_name: "FurColor"
  belongs_to :secondary_color, class_name: "FurColor"
  belongs_to :primary_breed, class_name: "Breed"
  belongs_to :secondary_breed, class_name: "Breed"
  has_many :bonds, dependent: :destroy
  has_many :watchers, through: :bonds, source: :user
  has_many :microposts, dependent: :destroy
  has_many :pet_photos, dependent: :destroy
  has_many :pet_videos, dependent: :destroy
  has_many :journals, dependent: :destroy
  
  accepts_nested_attributes_for :shelter
  accepts_nested_attributes_for :species
  accepts_nested_attributes_for :gender
  accepts_nested_attributes_for :size
  accepts_nested_attributes_for :age_period
  accepts_nested_attributes_for :affection
  accepts_nested_attributes_for :energy_level
  accepts_nested_attributes_for :nature
  accepts_nested_attributes_for :primary_color
  accepts_nested_attributes_for :secondary_color
  accepts_nested_attributes_for :fur_length
  
  validates :name, length: { maximum: 40 }
  validates :description, presence: true, length: { maximum: 800 }
  validates :user_id, presence: true
  validates :size_id, presence: true
  validates :animal_code, presence: true
  validates :gender_id, presence: true
  validates :species_id, presence: true
  validates :pet_state_id, presence: true
  validates :shelter_id, presence: true
  validates :age, presence: true, numericality: { greater_than: 0, less_than: 250 }
  validates :age_period_id, presence: true
  validates :weight, numericality: { greater_than: 0, less_than: 250 }, allow_blank: true
  validates :affection_id, presence: true
  validates :energy_level_id, presence: true
  validates :nature_id, presence: true
  validates :primary_color_id, presence: true
  validates :fur_length_id, presence: true
  validates :primary_breed_id, presence: true
  validates :slug, uniqueness: true, presence: true

  validate :check_color_match
  validate :check_breed_match
  
  before_validation :generate_slug, on: :create
  before_validation :regenerate_slug, on: :update, if: :name_changed?
  before_validation :regenerate_slug, on: :update, if: :shelter_id_changed?
  before_validation :convert_values, on: :create

  default_scope order: 'pets.created_at DESC'

  profanity_filter :name, :description

  def to_param
    slug
  end
  
  def journalize!(shelter, pet_state, old_pet_state)
    #old_state = cookies[:pet_state_change]
    if old_pet_state
      journals.create!(shelter_id: shelter.id, pet_state_id: pet_state.id, old_pet_state_id: old_pet_state.values[0])
    else
      journals.create!(shelter_id: shelter.id, pet_state_id: pet_state.id, old_pet_state_id: old_pet_state)
    end
  end
  
  def feed
    microposts
  end
  
  def self.search(search)
    if search
      #where('name iLIKE ?', "%#{search}%")
      find(:all, conditions: ['name iLIKE :search OR animal_code iLIKE :search', {search: "%#{search}%"}])
    else
      scoped
    end
  end
  
  def age_group
    split_age = current_age.split
    age_value = split_age[0].to_i
    period = split_age[1]
    
    if period == "year" && age_value > 1
      if age_value > 9
        group = "senior"
      else
        group = "adult"
      end
    else
      group = "young"
    end
    
    return group
  end
  
  def current_age
    s_day = 86400
    s_week = 604800
    s_month = 2628000
    s_year = 31536000
    
    if self.age_period.length == "day"
      raw = self.age * s_day
    elsif self.age_period.length == "week"
      raw = self.age * s_week
    elsif self.age_period.length == "month"
      raw = self.age * s_month
    else self.age_period.length == "year"
      raw = self.age * s_year
    end
    
    elapsed = Time.now - (self.created_at.kind_of?(Time) ? self.created_at : Time.parse(self.created_at))
    temp = raw + elapsed
    
    if temp < s_week * 2
      current = (temp / s_day).round.to_s + " day"
    elsif temp < s_month * 4
      current = (temp / s_week).round.to_s + " week"
    elsif temp < s_year * 2
      current = (temp / s_month).round.to_s + " month"
    else
      current = (temp / s_year).round.to_s + " year"
    end
    
    return current
  end
  
  def self.addpet(addpet)
    @pet == Pet.all.find{|p| p.animal_code == params[:addpet] }
    alert(@pet.name)
    if @pet.nil?
      #redirect_to newpet_path
    else
      redirect_to [@pet.shelter, @pet]
    end
  end
  
  def shelter_name
    shelter.try(:name)
  end

  def shelter_name=(name)
    self.shelter = Shelter.find_by_name(name) if name.present?
  end
  
  def primary_breed_name
    primary_breed.try(:name)
  end

  def primary_breed_name=(name)
    self.primary_breed = Breed.find_by_name(name) if name.present?
  end

  def secondary_breed_name
    secondary_breed.try(:name)
  end

  def secondary_breed_name=(name)
    if name.present? && name != ""
      self.secondary_breed = Breed.find_by_name(name)
    else
      self.secondary_breed = nil
    end
  end
  
  private
  
    def generate_slug
      if name != ""
        self.slug ||= name.parameterize.titleize.gsub(" ","")
      else
        self.slug ||= animal_code.parameterize.titleize.gsub(" ","")
      end
      while Pet.find{|s| s.slug == self.slug} do
        self.slug = self.slug + Random.rand(1..9).to_s
      end
    end
 
    def regenerate_slug
      if name != ""
        self.slug = name.parameterize.titleize.gsub(" ","")
      else
        self.slug = animal_code.parameterize.titleize.gsub(" ","")
      end
      while Pet.find{|s| s.slug == self.slug} do
        self.slug = self.slug + Random.rand(1..9).to_s
      end
    end 
    
    def convert_values
      self.age = age.to_f
      self.size_id = size_id.to_i
      self.pet_state_id = 1
      self.shelter_id = shelter_id.to_i
    end
    
    def check_color_match
      if secondary_color == primary_color
        errors.add(:secondary_color, " must be different than the primary color")
      end
    end
    
    def check_breed_match
      if !secondary_breed.nil? && secondary_breed == primary_breed
        errors.add(:secondary_breed, " must be different than the primary breed")
      end
    end

end
