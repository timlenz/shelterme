# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean         default(FALSE)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  location               :string(255)
#  bio                    :text
#  phone                  :string(255)
#  latitude               :float
#  longitude              :float
#  manager                :boolean         default(FALSE)
#  shelter_id             :integer
#  open_value_id          :integer
#  plan_value_id          :integer
#  social_value_id        :integer
#  attitude_value_id      :integer
#  emotion_value_id       :integer
#  clean_value_id         :integer
#  energy_value_id        :integer
#  species_id             :integer
#

class User < ActiveRecord::Base 
  attr_accessible :name, :email, :password, :password_confirmation, :location,
                  :bio, :phone, :latitude, :longitude, :admin, :shelter_id, :manager,
                  :shelter_name, :open_value_id, :plan_value_id, :social_value_id,
                  :attitude_value_id, :emotion_value_id, :clean_value_id,
                  :energy_value_id, :species_id, :open_value_attributes,
                  :plan_value_attributes, :social_value_attributes, :attitude_value_attributes,
                  :emotion_value_attributes, :clean_value_attributes,
                  :energy_value_attributes, :species_attributes
  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name: "Relationship",
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  has_many :pets
  has_many :bonds, dependent: :destroy
  has_many :watched_pets, through: :bonds, source: :pet
  has_many :favorites, dependent: :destroy
  has_many :boosted_shelters, through: :favorites, source: :shelter
  belongs_to :shelter
  belongs_to :open_value
  belongs_to :plan_value
  belongs_to :social_value
  belongs_to :attitude_value
  belongs_to :emotion_value
  belongs_to :clean_value
  belongs_to :energy_value
  belongs_to :species
  before_save { generate_token(:remember_token) }

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  #validates :location, presence: true
  
  accepts_nested_attributes_for :open_value
  accepts_nested_attributes_for :plan_value
  accepts_nested_attributes_for :social_value
  accepts_nested_attributes_for :attitude_value
  accepts_nested_attributes_for :emotion_value
  accepts_nested_attributes_for :clean_value
  accepts_nested_attributes_for :energy_value
  accepts_nested_attributes_for :species
  
  geocoded_by :location
  after_validation :geocode
  
  profanity_filter :name, :bio, :location
  
  def feed
    #Micropost.from_users_followed_by(self)
    microposts
  end
  
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end
  
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end
  
  def watching?(pet)
    bonds.find_by_pet_id(pet.id)
  end
  
  def watch!(pet)
    bonds.create!(pet_id: pet.id)
  end
  
  def unwatch!(pet)
    bonds.find_by_pet_id(pet.id).destroy
  end

  def boosting?(shelter)
    favorites.find_by_shelter_id(shelter.id)
  end

  def boost!(shelter)
    favorites.create!(shelter_id: shelter.id)
  end

  def unboost!(shelter)
    favorites.find_by_shelter_id(shelter.id).destroy
  end
  
  def managing?(shelter)
    shelter_admins.find_by_shelter_id(shelter.id)
  end

  def manage!(shelter)
    shelter_admins.create!(shelter_id: shelter.id)
  end

  def unmanage!(shelter)
    shelter_admins.find_by_shelter_id(shelter.id).destroy
  end
  
  def shelter_name
    shelter.try(:name)
  end

  def shelter_name=(name)
    self.shelter = Shelter.find_by_name(name) if name.present?
  end
  
  def matchme
    u_char = ["curious", "cautious", "spontaneous", "disciplined", "quiet", "enthusiastic", 
              "skeptical", "considerate", "calm", "anxious", "orderly", "cluttered", "relaxed", "active"]
    p_char = ["submissive", "playful", "dominant", "relaxed", "balanced", "tireless", 
              "devoted", "friendly", "reserved"]
    matrix = [[0, 0.5, 1, 0, 0.5, 1, 0, 1, 0],
              [1, 0.5, 0, 1, 0.5, 0, 1, 0.5, -0.5],
              [0, 0.5, 1, 0, 0.5, 1, -0.5, 1, 0],
              [1, 0.5, 0, 1, 0.5, 0, 1, 0.5, 0],
              [1, 0.5, 0, 1, 0.5, 0, 1, 0.5, 0],
              [0, 0.5, 1, 0, 0.5, 1, 0, 1, 0],
              [1, 0.5, 0, 1, 0.5, 0, 1, 0.5, -0.5],
              [0, 0.5, 1, 0, 0.5, 1, 0, 0.5, 1],
              [0, 1, 0.5, 0, 1, 0.5, 1, 1, 1],
              [0.5, 1, 0, 0.5, 1, 0, 0.5, 1, -0.5],
              [1, 0.5, 0, 1, 0.5, 0, -1, -0.5, 0],
              [0, 0.5, 1, 0, 0.5, 1, -1, -0.5, 0],
              [1, 0.5, 0, 1, 0.5, 0, 1, 0.5, 0],
              [0, 0.5, 1, 0, 0.5, 1, 0.5, 1, -0.5]]
    mo = [1, 0.5, 0.5, 0.5, 1.5, 0.5, 0.5, 1, -2, 0, 0, 1, 1, -0.5, 0.5, -2, 2, 1, 1,
          1.5, -1.5, 0, -1, 1, 0, -2, 1, -1, 2, 0, 0, 2, 1, 1, 1, 1]      
    nearbys = Shelter.near(location, 50, order: "distance").map{|s| s.id}# if location.present?
    scores = Array.new
    @matches = Pet.order(:name)
    @matches = @matches.where('shelter_id in (?)', nearbys)# if location.present?
    @matches = @matches.where(species_id: species_id) if species_id.present?
    @matches = @matches.select{|p| p.pet_state.status == "available"}
    # Calculate match scores for pets in array against user's characteristics
    @matches = @matches.each_with_index do |p, i|
    	n_col = p_char.index(p.nature.name)
    	el_col = p_char.index(p.energy_level.level)
    	a_col = p_char.index(p.affection.name)
    	if open_value_id.present?
    	  row = u_char.index(OpenValue.all[open_value_id - 1].name)
    	  scores[i] = matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if plan_value_id.present?
    	  row = u_char.index(PlanValue.all[plan_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if social_value_id.present?
    	  row = u_char.index(SocialValue.all[social_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if attitude_value_id.present?
    	  row = u_char.index(AttitudeValue.all[attitude_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if emotion_value_id.present?
    	  row = u_char.index(EmotionValue.all[emotion_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if clean_value_id.present?
    	  row = u_char.index(CleanValue.all[clean_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    	if energy_value_id.present?
    	  row = u_char.index(EnergyValue.all[energy_value_id - 1].name)
    	  scores[i] = scores[i] + matrix[row][n_col] + matrix[row][el_col] + matrix[row][a_col]
    	end
    end
    # Combine match scores with pets in two-dimensional array
    @matches = @matches.zip(scores)
    # Modify match scores with mo lookup
    @matches = @matches.each{|v| v[1] = v[1] + mo[Random.rand(0..35)]}
    # Limit to those pets with maximum modified match score
    @matches = @matches.select{|p| p[1] == @matches.map{|v| v[1]}.max}
    #recapture just the array of pets, stripping out match values
    @matches = @matches.map{|p| p[0]}
    # sort by closest shelter
    @matches = @matches.sort_by {|s| nearbys.index(s.send(:shelter_id))}# if location.present?
    $match = true
    @matches
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def self.search(search)
    if search
      where('name iLIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  #private
    def generate_token(column)    # generate_remember_token
      begin
        self[column] = SecureRandom.urlsafe_base64    # eliminate [column]
      end while User.exists?(column => self[column])  # eliminate while...
    end
end
