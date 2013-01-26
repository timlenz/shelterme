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
  before_save { |user| user.email = email.downcase }
  before_save { generate_token(:remember_token) }

  validates :name, presence: true, length: { maximum: 50 }
  validates :bio, length: { maximum: 520 }
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
  before_validation :generate_slug, on: :create
  after_validation :geocode
  
  profanity_filter :name, :bio, :location
  
  def to_param
    slug
  end
  
  def generate_slug
    self.slug ||= name.parameterize.titleize.gsub(" ","")
    while User.find{|s| s.slug == self.slug} || Shelter.find{|s| s.slug == self.slug} do
      self.slug = self.slug + Random.rand(1..9).to_s
    end
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
    nearbys = Shelter.near(location, 200, order: "distance").map{|s| s.id}
    scores = Array.new
    @matches = Pet.order(:name)
    @matches = @matches.where('shelter_id in (?)', nearbys)
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
    @matches = @matches.sort_by {|s| nearbys.index(s.send(:shelter_id))}
    $match = true
    @matches
  end
  
  def ave_affection
    low = pets.select{|p| p.affection.name == 'reserved'}.count + watched_pets.select{|p| p.affection.name == 'reserved'}.count
    mid = pets.select{|p| p.affection.name == 'friendly'}.count + watched_pets.select{|p| p.affection.name == 'friendly'}.count
    high = pets.select{|p| p.affection.name == 'devoted'}.count + watched_pets.select{|p| p.affection.name == 'devoted'}.count
    affection = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
  end
  
  def ave_ageGender
    low = pets.select{|p| p.age_group == 'young'}.count + watched_pets.select{|p| p.age_group == 'young'}.count
    mid = pets.select{|p| p.age_group == 'adult'}.count + watched_pets.select{|p| p.age_group == 'adult'}.count
    high = pets.select{|p| p.age_group == 'senior'}.count + watched_pets.select{|p| p.age_group == 'senior'}.count
    age = ["young", "adult", "senior"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    male = pets.select{|p| p.gender.sex == 'male'}.count + watched_pets.select{|p| p.gender.sex == 'male'}.count
    female = pets.select{|p| p.gender.sex == 'female'}.count + watched_pets.select{|p| p.gender.sex == 'female'}.count
    gender = male > female ? "Male" : "Female"
    return age + gender
  end
  
  def ave_coat
    short = pets.select{|p| p.fur_length.length == 'short'}.count + watched_pets.select{|p| p.fur_length.length == 'short'}.count
    medium = pets.select{|p| p.fur_length.length == 'medium'}.count + watched_pets.select{|p| p.fur_length.length == 'medium'}.count
    long = pets.select{|p| p.fur_length.length == 'long'}.count + watched_pets.select{|p| p.fur_length.length == 'long'}.count
    length = ["short", "medium", "long"].fetch( ( (short + medium * 2 + long * 3) / (short + medium + long) ).round - 1 )
    primary_color_count = pets.map{|p| p.primary_color}.compact.count + watched_pets.map{|p| p.primary_color}.compact.count
    secondary_color_count = pets.map{|p| p.secondary_color}.compact.count + watched_pets.map{|p| p.secondary_color}.compact.count
    pet_count = pets.count + watched_pets.count
    primary = pets.map{|p| p.primary_color}.compact.map{|c| c.color} + watched_pets.map{|p| p.primary_color}.compact.map{|c| c.color}
    secondary = pets.map{|p| p.secondary_color}.compact.map{|c| c.color} + watched_pets.map{|p| p.secondary_color}.compact.map{|c| c.color}
    colors = (primary + secondary).inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries
    one_or_two = ((primary_color_count + secondary_color_count) / pet_count ).round
    one_color = colors.max_by {|entry| entry.last}.first.capitalize.gsub(/-/,"")
    first_of_two = colors.sort_by{|k,v| v}.reverse.first.first.capitalize.gsub(/Tri-color/,"")
    second_of_two = colors.sort_by{|k,v| v}.reverse.second.first.capitalize.gsub(/Tri-color/,"")
    color = ( one_or_two == 1 ) ? one_color : first_of_two + second_of_two
    return length + color
  end
  
  def ave_energy
    low = pets.select{|p| p.energy_level.level == 'relaxed'}.count + watched_pets.select{|p| p.energy_level.level == 'relaxed'}.count
    mid = pets.select{|p| p.energy_level.level == 'balanced'}.count + watched_pets.select{|p| p.energy_level.level == 'balanced'}.count
    high = pets.select{|p| p.energy_level.level == 'tireless'}.count + watched_pets.select{|p| p.energy_level.level == 'tireless'}.count
    energy = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
  end
  
  def ave_nature
    low = pets.select{|p| p.nature.name == 'submissive'}.count + watched_pets.select{|p| p.nature.name == 'submissive'}.count
    mid = pets.select{|p| p.nature.name == 'playful'}.count + watched_pets.select{|p| p.nature.name == 'playful'}.count
    high = pets.select{|p| p.nature.name == 'dominant'}.count + watched_pets.select{|p| p.nature.name == 'dominant'}.count
    level = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    dog = pets.select{|p| p.species.name == 'dog'}.count + watched_pets.select{|p| p.species.name == 'dog'}.count
    cat = pets.select{|p| p.species.name == 'cat'}.count + watched_pets.select{|p| p.species.name == 'cat'}.count
    species = dog > cat ? "Dog" : "Cat"
    nature = level + species
  end
  
  def ave_sizeSpecies
    low = pets.select{|p| p.size.name == 'small'}.count + watched_pets.select{|p| p.size.name == 'small'}.count
    mid = pets.select{|p| p.size.name == 'medium'}.count + watched_pets.select{|p| p.size.name == 'medium'}.count
    high = pets.select{|p| p.size.name == 'large'}.count + watched_pets.select{|p| p.size.name == 'large'}.count
    level = ["low", "mid", "high"].fetch( ( (low + mid * 2 + high * 3) / (low + mid + high) ).round - 1 )
    dog = pets.select{|p| p.species.name == 'dog'}.count + watched_pets.select{|p| p.species.name == 'dog'}.count
    cat = pets.select{|p| p.species.name == 'cat'}.count + watched_pets.select{|p| p.species.name == 'cat'}.count
    species = dog > cat ? "Dog" : "Cat"
    nature = level + "Size" + species
  end
  
  def ave_weight
    if self.pets.count > 0 && self.watched_pets.count > 0
      weights = pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el} + watched_pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
      weight = ( weights / (pets.count + watched_pets.count) ).round
    else
      if self.pets.count > 0
        weights = pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
        weight = ( weights / pets.count ).round
      else       
        weights = watched_pets.map{|p| p.weight.to_i}.inject{|sum, el| sum + el}
        weight = ( weights / watched_pets.count ).round
      end  
    end
  end
  
  def activity
    # Followed users
    fu = relationships.map{|r| [self, r.followed, r.created_at, "Followed"]}
    if fu.count > 0
      # Users followed by followed users
      fufu = fu.map{|fu| fu[1]}.map{|fufu| fufu.relationships}.map{|x| x}.flatten.map{|r| [r.follower, r.followed, r.created_at, "Followed"]}
      # Pets sponsored by followed users
      fusp = fu.map{|fu| fu[1]}.map{|fusp| fusp.pets}.map{|x| x}.flatten.map{|p| [p.user, p, p.created_at, "Added"]}
      # Pets followed by followed users
      fuwp = fu.map{|fu| fu[1]}.map{|fuwp| fuwp.bonds}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "Started Following"]}
      # Shelters boosted by followed users
      fubs = fu.map{|fu| fu[1]}.map{|u| Favorite.select{|f| f.user == u}}.flatten.map{|f| [f.user, f.shelter, f.created_at, "Favorite"]}
      # Comments added by followed users
      fum = fu.map{|fu| fu[1]}.map{|fum| fum.microposts}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Photos added by followed users
      fup = fu.map{|fu| fu[1]}.map{|s| PetPhoto.select{|u| u.user == s}}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Videos added by followed users
      fuv = fu.map{|fu| fu[1]}.map{|s| PetVideo.select{|u| u.user == s}}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
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
    wp = bonds.map{|b| [b.user, b.pet, b.created_at, "Started Following"]}
    if wp.count > 0
      # Watched pets status changes
      wpst = bonds.map{|b| [b.user, b.pet, b.updated_at, "state", b.pet.pet_state.status]}
      # Watched pets new watchers
      wwp = wp.map{|wp| wp[1]}.map{|wwp| wwp.bonds}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch"]}.reject{|u| u[0] == self}
      # Watched pets comments
      wm = wwp.map{|wwp| wwp[1].microposts}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Watched pets new photos (also include - eventually - name of person who added media)
      wpp = wp.map{|wp| wp[1]}.map{|wpp| wpp.pet_photos}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Watched pets new videos (also include - eventually - name of person who added media)
      wpv = wp.map{|wp| wp[1]}.map{|wpv| wpv.pet_videos}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
    else
      wpst = []
      wwp = []
      wm = []
      wpp = []
      wpv = []
    end
    wpa = wp + wpst + wwp + wm + wpp + wpv
    
    # Sponsored pets
    sp = pets.map{|p| [self, p, p.created_at, "Added"]}
    if sp.count > 0
      # Sponsored pets status changes
      spst = pets.map{|p| [self, p, p.updated_at, "state", p.pet_state.status]}
      # Sponsored pets new watchers
      wsp = sp.map{|sp| sp[1]}.map{|wsp| wsp.bonds}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch"]}
      # Sponsored pets comments
      sm = wsp.map{|wsp| wsp[1].microposts}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post", mp.content ]}
      # Sponsored pets new photos (also include - eventually - name of person who added media)
      spp = sp.map{|sp| sp[1]}.map{|spp| spp.pet_photos}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo", p]}
      # Sponsored pets new videos (also include - eventually - name of person who added media)
      spv = sp.map{|sp| sp[1]}.map{|spv| spv.pet_videos}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video", v]}
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
      mp = self.shelter.pets.map{|p| [p.user, p, p.created_at, "Managed"]}
      # Managed pets status changes
      mpst = self.shelter.pets.map{|p| [p.user, p, p.updated_at, "state", p.pet_state.status]}
      # Managed pets new watchers
      wmp = mp.map{|mp| mp[1]}.map{|wmp| wmp.bonds}.map{|x| x}.flatten.map{|b| [b.user, b.pet, b.created_at, "watch managed"]}
      # Managed pets new comments
      mm = wmp.map{|wmp| wmp[1].microposts}.reject{|x| x.empty?}.flatten.map{|mp| [ mp.user, mp.pet, mp.created_at, "post managed", mp.content ]}
      # Managed pets new photos (also include - eventually - name of person who added media)
      mpp = mp.map{|mp| mp[1]}.map{|mpp| mpp.pet_photos}.map{|x| x}.flatten.map{|p| [p.user, p.pet, p.created_at, "photo managed", p]}
      # Managed pets new videos (also include - eventually - name of person who added media)
      mpv = mp.map{|mp| mp[1]}.map{|mpv| mpv.pet_videos}.map{|x| x}.flatten.map{|v| [v.user, v.pet, v.created_at, "video managed", v]}
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
    # [user, pet/shelter, created_at, message, status/comment, media]
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
end
