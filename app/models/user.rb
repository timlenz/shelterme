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
#  slug                   :string(255)
#  avatar                 :string(255)
#

class User < ActiveRecord::Base 
  attr_accessible :name, :email, :password, :password_confirmation, :location,
                  :bio, :phone, :latitude, :longitude, :admin, :shelter_id, :manager,
                  :shelter_name, :open_value_id, :plan_value_id, :social_value_id,
                  :attitude_value_id, :emotion_value_id, :clean_value_id,
                  :energy_value_id, :species_id, :open_value_attributes,
                  :plan_value_attributes, :social_value_attributes, :attitude_value_attributes,
                  :emotion_value_attributes, :clean_value_attributes,
                  :energy_value_attributes, :species_attributes, :avatar, :avatar_cache

  has_secure_password
  has_many :microposts#, dependent: :destroy DON'T DELETE USER COMMENTS WITH USER
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
  before_save { |user| user.email = email.downcase }
  before_save { generate_token(:remember_token) }

  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, length: { maximum: 480 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, on: :create
  validates :password_confirmation, presence: true, on: :create
  validates :slug, uniqueness: true, presence: true
  
  accepts_nested_attributes_for :open_value
  accepts_nested_attributes_for :plan_value
  accepts_nested_attributes_for :social_value
  accepts_nested_attributes_for :attitude_value
  accepts_nested_attributes_for :emotion_value
  accepts_nested_attributes_for :clean_value
  accepts_nested_attributes_for :energy_value
  accepts_nested_attributes_for :species
  
  geocoded_by :location
  profanity_filter :name, :bio, :location
  mount_uploader :avatar, AvatarUploader
  
  before_validation :generate_slug, on: :create
  after_validation :geocode
  
  def to_param
    slug
  end
  
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
              "cynical", "considerate", "calm", "impatient", "orderly", "cluttered", "relaxed", "active"]
    p_char = ["submissive", "playful", "confident", "relaxed", "moderate", "energetic", 
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
    distance = 100 # start with 100 mile search radius for rural users
    nearbys = Shelter.near(location, distance, order: "distance").map{|s| s.id} if location.present?
    if nearbys
      while nearbys.size > 3 do # shrink search radius until no more than three shelters in nearbys
        distance -= 10
        nearbys = Shelter.near(location, distance, order: "distance").map{|s| s.id} if location.present?
      end
      scores = Array.new
      @matches = Pet.where('shelter_id in (?)', nearbys)
      @matches = @matches.where(species_id: species_id) if species_id.present?
      @matches = @matches.where(pet_state_id: 1)
      @matches = @matches.where('pet_photos_count > 0') # Don't show any pets that don't have photos
      if !@matches.blank?
        # Calculate match scores for pets in array against user's characteristics
        @matches = @matches.each_with_index do |p, i|
          n_col = p_char.index(p.nature.name)
          el_col = p_char.index(p.energy_level.level)
          a_col = p_char.index(p.affection.name)
          if open_value_id.present?
            row = u_char.index(OpenValue.all[open_value_id - 1].name).to_i
            scores[i] = matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if plan_value_id.present?
            row = u_char.index(PlanValue.all[plan_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if social_value_id.present?
            row = u_char.index(SocialValue.all[social_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if attitude_value_id.present?
            row = u_char.index(AttitudeValue.all[attitude_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if emotion_value_id.present?
            row = u_char.index(EmotionValue.all[emotion_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if clean_value_id.present?
            row = u_char.index(CleanValue.all[clean_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
          end
          if energy_value_id.present?
            row = u_char.index(EnergyValue.all[energy_value_id - 1].name)
            scores[i] = scores[i] + matrix[row][n_col].to_i + matrix[row][el_col].to_i + matrix[row][a_col].to_i
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
        @matches = @matches.sample(3)
        @matches = @matches.sort_by {|s| nearbys.index(s.send(:shelter_id))}
      else
        @matches = []
      end
    else
      @matches = []
    end
  end
  
  def ave_affection
    low = pets.where(affection_id: 3).size + watched_pets.where(affection_id: 3).size # reserved
    mid = pets.where(affection_id: 2).size + watched_pets.where(affection_id: 2).size # friendly
    high = pets.where(affection_id: 1).size + watched_pets.where(affection_id: 1).size # devoted
    affection = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
  end
  
  def ave_ageGender
    low = pets.includes(:age_period).select{|p| p.age_group == 'young'}.size + watched_pets.includes(:age_period).select{|p| p.age_group == 'young'}.size
    mid = pets.includes(:age_period).select{|p| p.age_group == 'adult'}.size + watched_pets.includes(:age_period).select{|p| p.age_group == 'adult'}.size
    high = pets.includes(:age_period).select{|p| p.age_group == 'senior'}.size + watched_pets.includes(:age_period).select{|p| p.age_group == 'senior'}.size
    age = ["young", "adult", "senior"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    male = pets.where(gender_id: 1).size + watched_pets.where(gender_id: 1).size # male
    female = pets.where(gender_id: 2).size + watched_pets.where(gender_id: 2).size # female
    gender = male > female ? "Male" : "Female"
    return age + gender
  end
  
  def ave_coat
    short = pets.where(fur_length_id: 1).size + watched_pets.where(fur_length_id: 1).size # short
    medium = pets.where(fur_length_id: 2).size + watched_pets.where(fur_length_id: 2).size # medium
    long = pets.where(fur_length_id: 3).size + watched_pets.where(fur_length_id: 3).size # long
    length = ["short", "medium", "long"].fetch( ( (short + medium * 2 + long * 3) / (short + medium + long) ).round - 1 )
    primary_color_count = pets.includes(:primary_color).map{|p| p.primary_color}.compact.size + watched_pets.includes(:primary_color).map{|p| p.primary_color}.compact.size
    secondary_color_count = pets.includes(:secondary_color).map{|p| p.secondary_color}.compact.size + watched_pets.includes(:secondary_color).map{|p| p.secondary_color}.compact.size
    pet_count = pets.size + watched_pets.size
    primary = pets.map{|p| p.primary_color}.compact.map{|c| c.color} + watched_pets.map{|p| p.primary_color}.compact.map{|c| c.color}
    secondary = pets.map{|p| p.secondary_color}.compact.map{|c| c.color} + watched_pets.map{|p| p.secondary_color}.compact.map{|c| c.color}
    colors = (primary + secondary).inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries
    one_or_two = ((primary_color_count + secondary_color_count) / pet_count ).round
    one_color = colors.max_by {|entry| entry.last}.first.capitalize.gsub(/-/,"")
    if one_or_two > 1
      first_of_two = colors.sort_by{|k,v| v}.reverse.first.first.capitalize
      second_of_two = colors.sort_by{|k,v| v}.reverse.second.first.capitalize
      if ((first_of_two == "red" || first_of_two == "yellow") && second_of_two == "orange") ||
        ((second_of_two == "red" || second_of_two == "yellow") && first_of_two == "orange")
        one_or_two = 1
      end
    end
    color = ( one_or_two == 1 ) ? one_color : first_of_two + second_of_two
    return length + color
  end
  
  def ave_energy
    low = pets.where(energy_level_id: 1).size + watched_pets.where(energy_level_id: 1).size # relaxed
    mid = pets.where(energy_level_id: 2).size + watched_pets.where(energy_level_id: 2).size # moderate
    high = pets.where(energy_level_id: 3).size + watched_pets.where(energy_level_id: 3).size # energetic
    energy = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
  end
  
  def ave_nature
    low = pets.where(nature_id: 1).size + watched_pets.where(nature_id: 1).size # submissive
    mid = pets.where(nature_id: 2).size + watched_pets.where(nature_id: 2).size # playful
    high = pets.where(nature_id: 3).size + watched_pets.where(nature_id: 3).size # confident
    level = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    dog = pets.where(species_id: 2).size + watched_pets.where(species_id: 2).size # dog
    cat = pets.where(species_id: 1).size + watched_pets.where(species_id: 1).size # cat
    species = dog > cat ? "Dog" : "Cat"
    nature = level + species
  end
  
  def ave_sizeSpecies
    low = pets.where(size_id: 1).size + watched_pets.where(size_id: 1).size # small
    mid = pets.where(size_id: 2).size + watched_pets.where(size_id: 2).size # medium
    high = pets.where(size_id: 3).size + watched_pets.where(size_id: 3).size # large
    level = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    dog = pets.where(species_id: 2).size + watched_pets.where(species_id: 2).size # dog
    cat = pets.where(species_id: 1).size + watched_pets.where(species_id: 1).size # cat
    species = dog > cat ? "Dog" : "Cat"
    nature = level + "Size" + species
  end
  
  def ave_weight
    if self.pets.size > 0 && self.watched_pets.size > 0
      weights = pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el} + watched_pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
      weight = ( weights / (pets.size + watched_pets.size) ).round
    else
      if self.pets.size > 0
        weights = pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
        weight = ( weights / pets.size ).round
      else       
        weights = watched_pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
        weight = ( weights / watched_pets.size ).round
      end  
    end
  end
  
  def activity
    # Followed users
    fu = relationships.map{|r| [self, r.followed, r.created_at, "Followed"]}
    if fu.size > 0
      # Users followed by followed users
      fufu = fu.map{|fu| fu[1]}.map{|fufu| fufu.relationships}.map{|x| x}.flatten.map{|r| [r.follower, r.followed, r.created_at, "Followed"]}
      # Pets sponsored by followed users
      fusp = fu.map{|fu| fu[1]}.map{|fusp| fusp.pets.includes(:user)}.map{|x| x}.flatten.map{|p| [p.user, p, p.created_at, "Added"]}
      # Pets followed by followed users
      fuwp = fu.map{|fu| fu[1]}.map{|fuwp| fuwp.bonds.includes(:user, :pet)}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "Started Following"]}
      # Shelters boosted by followed users
      fubs = fu.map{|fu| fu[1]}.map{|u| Favorite.where(user_id: u.id)}.flatten.map{|f| [f.user, f.shelter, f.created_at, "Favorite"]}
      # Comments added by followed users
      fum = fu.map{|fu| fu[1]}.map{|fum| fum.microposts.includes(:user, pet: :shelter)}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Photos added by followed users
      fup = fu.map{|fu| fu[1]}.map{|s| PetPhoto.where(user_id: s.id).includes(:user)}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Videos added by followed users
      fuv = fu.map{|fu| fu[1]}.map{|s| PetVideo.where(user_id: s.id).includes(:user)}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
    else
      fufu = []
      fusp = []
      fuwp = []
      fubs = []
      fum = []
      fup = []
      fuv = []
    end
    fua = fu + fufu + fusp + fuwp + fubs + fum + fup + fuv
    
    # Users following user
    fme = reverse_relationships.map{|r| [self, r.follower, r.created_at, "Following"]}
    # Followed (boosted) shelters
    bs = boosted_shelters.map{|b| [self, b, b.created_at, "Favorite"]}
    
    # Watched pets
    wp = bonds.includes(:user, :pet).map{|b| [b.user, b.pet, b.created_at, "Started Following"]}
    if wp.size > 0
      # Watched pets status changes
      wpst = bonds.map{|b| [b.user, b.pet, b.updated_at, "state", b.pet.pet_state.status]}
      # Watched pets new watchers
      wwp = wp.map{|wp| wp[1]}.map{|wwp| wwp.bonds.includes(:user, :pet)}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch"]}.reject{|u| u[0] == self}
      # Watched pets comments
      wm = wwp.map{|wwp| wwp[1].microposts.includes(:user, :pet)}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Watched pets new photos (also include - eventually - name of person who added media)
      wpp = wp.map{|wp| wp[1]}.map{|wpp| wpp.pet_photos.includes(:user, :pet)}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Watched pets new videos (also include - eventually - name of person who added media)
      wpv = wp.map{|wp| wp[1]}.map{|wpv| wpv.pet_videos.includes(:user, :pet)}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
    else
      wpst = []
      wwp = []
      wm = []
      wpp = []
      wpv = []
    end
    wpa = wp + wpst + wwp + wm + wpp + wpv
    
    # Sponsored pets
    sp = pets.includes(:shelter, :pet_state, pet_photos: :user, pet_videos: :user).map{|p| [self, p, p.created_at, "Added"]}
    if sp.size > 0
      # Sponsored pets status changes
      spst = pets.map{|p| [self, p, p.updated_at, "state", p.pet_state.status]}
      # Sponsored pets new watchers
      wsp = sp.map{|sp| sp[1]}.map{|wsp| wsp.bonds.includes(:user)}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch"]}
      # Sponsored pets comments
      sm = wsp.map{|wsp| wsp[1].microposts.includes(:user, :pet)}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Sponsored pets new photos (also include - eventually - name of person who added media)
      spp = sp.map{|sp| sp[1]}.map{|spp| spp.pet_photos.includes(:pet)}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Sponsored pets new videos (also include - eventually - name of person who added media)
      spv = sp.map{|sp| sp[1]}.map{|spv| spv.pet_videos.includes(:pet)}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
    else
      spst = []
      wsp = []
      sm = []
      spp = []
      spv = []
    end
    spa = sp + spst + wsp + sm + spp + spv
    
    # Check if user is a shelter manager and gather activity for managed pets
    if self.shelter
      # Managed pets
      mp = self.shelter.pets.includes(:user, :bonds, :shelter).map{|p| [p.user, p, p.created_at, "Managed"]}
      # Managed pets status changes
      mpst = self.shelter.pets.includes(:pet_state).map{|p| [p.user, p, p.updated_at, "state", p.pet_state.status]}
      # Managed pets new watchers
      wmp = mp.map{|mp| mp[1]}.map{|wmp| wmp.bonds}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch managed"]}
      # Managed pets new comments
      mm = wmp.map{|wmp| wmp[1].microposts.includes(:user, :pet)}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post managed", mp.content ]}
      # Managed pets new photos (also include - eventually - name of person who added media)
      mpp = mp.map{|mp| mp[1]}.map{|mpp| mpp.pet_photos.includes(:pet, :user)}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo managed", p]}
      # Managed pets new videos (also include - eventually - name of person who added media)
      mpv = mp.map{|mp| mp[1]}.map{|mpv| mpv.pet_videos.includes(:pet, :user)}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video managed", v]}
    else
      mp = []
      mpst = []
      wmp = []
      mm = []
      mpp = []
      mpv = []
    end
    mpa = mp + mpst + wmp + mm + mpp + mpv
    
    # All pet activity sorted by date, most recent first
    ap = (fua + fme + bs + wpa + spa + mpa).uniq.sort!{|a,b| a[2] <=> b[2]}.reverse
    # [user, pet/shelter/other_user, created_at, message, status/comment, media]
    return ap
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
  
  private
    def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end
    
    def generate_slug
      self.slug = name.parameterize.titleize.gsub(" ","")
      while User.find{|s| s.slug == self.slug} do
        self.slug = self.slug + Random.rand(1..9).to_s
      end
    end
end
