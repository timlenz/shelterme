class StaticPagesController < ApplicationController
  
  def home
    respond_to do |format|
      format.html {
        require 'open-uri'
        require 'nokogiri'
        
        # TEMPORARY HACK TO ADD A SPECIFIC PET TO LIST
        # force_pet = Pet.where('slug iLIKE ?', "Nala4").where(pet_state_id: 1).first
        
        if cookies[:featured_pets] && cookies[:featured_shelter] && cookies[:featured_shelter_pets]
          @featured_pets = cookies[:featured_pets].split("&").map{|p| p.to_i}.map{|p| Pet.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(id: p, pet_state_id: 1)}.flatten
          
          # TEMPORARY HACK TO ADD A SPECIFIC PET TO LIST
          # if force_pet
          #   @featured_pets = @featured_pets.select{|p| p != force_pet}.sample(3).unshift(force_pet)
          # end
          
          @shelter = Shelter.where(id: cookies[:featured_shelter].to_i).first
          @shelter_pets = cookies[:featured_shelter_pets].split("&").map{|p| p.to_i}.map{|p| Pet.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color).where(id: p, pet_state_id: 1)}.flatten

        else  
          #
          # Set location in a cascade from most specific to least.
          # If option doesn't exist, or if validation of it fails, then move to next.
          # 1) value from location cookie
          # 2) current user location
          # 3) geocoder remote ip lookup
          # 4) failure handling of "mapquest not responding"
          #
          @location = "MapQuest not responding"
          if cookies[:location]
            @location = cookies[:location]
          end
          if (validate_location(@current_location) == false) && (signed_in? and current_user.location?)
            @location = current_user.location
          end
          if validate_location(@location) == false  
            s = Geocoder.search(remote_ip)
            @location = s[0].city + ", " + s[0].state_code
          end
          cookies[:location] = @location
          # added + ", US" as hack around Geonames location conflation issues with Canada & California
          shelters = Shelter.near(@location + ", US", 70, order: "distance")
          unless shelters.size > 0
            shelters = Shelter.near(@location + ", US", 200, order: "distance")
          end
          nearbys = shelters.map{|s| s.id}
          if @location != "MapQuest not responding" && nearbys.size > 0
            @pets = Pet.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :age_period, :shelter, :primary_color, :secondary_color)
            @pets = @pets.where('shelter_id in (?)', nearbys).where(pet_state_id: 1).where('pet_photos_count > 0') # Don't show any pets without photos
            if @pets.size > 0
              @featured_pets = @pets.includes(:pet_state).sample(12)
            
              # TEMPORARY HACK TO ADD A SPECIFIC PET TO LIST
              # if force_pet
              #   @featured_pets = @featured_pets.select{|p| p != force_pet}.sample(3).unshift(force_pet)
              # end
            
              @shelter = Shelter.find(@pets.includes(:pet_state).map{|sh| sh.shelter_id}.sample)
              @shelter_pets = @shelter.available.sample(12)
              # Add cache support for featured shelter across the site - and calculate once per day per location (if possible)
              cookies[:featured_pets] = { value: @featured_pets.map{|p| p.id}, expires: 1.day.from_now }
              cookies[:featured_shelter] = { value: @shelter.id, expires: 1.day.from_now }
              cookies[:featured_shelter_pets] = { value: @shelter_pets.map{|p| p.id}, expires: 1.day.from_now}
            else
              @featured_pets = []
              @shelter_pets = []
              @shelter = shelters.first
            end
          else
            @featured_pets = []
            @shelter = []
          end
        end
        # TEMPORARY HACK IN LIEU OF ASYNCHRONOUS LOADING & MEMCACHING OF BLOG CONTENT
        #@blog = true
        #blog = Nokogiri::XML(open("http://blog.shelterme.com/feed", read_timeout: 0.5))
        #if blog.nil?
         # @blog = false
        #else
        #  first_post = blog.xpath('//item').first
        #  @title = first_post.xpath('title').inner_text
        #  @link = first_post.xpath('link').inner_text
        #  @content = first_post.xpath('description').inner_text.html_safe
        #  image = Nokogiri::HTML.parse(first_post.xpath('content:encoded').inner_html).css('img')
        #  if image.empty?
        #    @image = "none"
        #  else
        #    @image = image.first.attribute("src").text
        #  end 
        #end
        @title = "I am a Proud Poppa of Three Shelter Dogs"
        @link = "http://blog.shelterme.com/i-am-a-proud-poppa-of-three-shelter-dogs/".html_safe
        @content = "Do you have photos of your pets at work? Do you post pictures of them on Facebook? When you are with friends do you just have to show a photo (or three) of your pets on your phone? Then you have come to the right place. My name is Steven Latham and I am crazy about my dogs.".html_safe
        @image = "http://blog.shelterme.com/wp-content/uploads/2013/04/Steven_Dogs-300x225.jpg".html_safe
      }
    end
  rescue Timeout::Error
    @blog = false
  rescue
    @featured_pets = []
    @shelter = []
    cookies[:location] = "MapQuest not responding"
    flash[:notice] = "There are no shelters near your location."
  end
  
  def about
  end
  
  def statistics
    if !signed_in?
      redirect_to root_path
    end
    @available_pets = Pet.where(pet_state_id: 1).size
    @adopted_pets = Pet.where(pet_state_id: 2).size
    @unavailable_pets = Pet.where(pet_state_id: 3).size
    @absent_pets = Pet.where(pet_state_id: 4).size
    @fostered_pets = Pet.where(pet_state_id: 5).size
    @rescued_pets = Pet.where(pet_state_id: 6).size
    @cats = Pet.where(species_id: 1).size
    @dogs = Pet.where(species_id: 2).size
    @available_cats = Pet.where(species_id: 1, pet_state_id: 1).size
    @adopted_cats = Pet.where(species_id: 1, pet_state_id: 2).size
    @unavailable_cats = Pet.where(species_id: 1, pet_state_id: 3).size
    @absent_cats = Pet.where(species_id: 1, pet_state_id: 4).size
    @fostered_cats = Pet.where(species_id: 1, pet_state_id: 5).size
    @rescued_cats = Pet.where(species_id: 1, pet_state_id: 6).size
    @available_dogs = Pet.where(species_id: 2, pet_state_id: 1).size
    @adopted_dogs = Pet.where(species_id: 2, pet_state_id: 2).size
    @unavailable_dogs = Pet.where(species_id: 2, pet_state_id: 3).size
    @absent_dogs = Pet.where(species_id: 2, pet_state_id: 4).size
    @fostered_dogs = Pet.where(species_id: 2, pet_state_id: 5).size
    @rescued_dogs = Pet.where(species_id: 2, pet_state_id: 6).size
    @users = User.all.size
    @managers = User.where(manager: true).size
    @admins = User.where(admin: true).size
    @shelters = Shelter.all.size
    @names = Pet.all.map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @dog_names = Pet.where(species_id: 2).map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @cat_names = Pet.where(species_id: 1).map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @available_journal = Shelter.all.map{|s| s.available_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @absent_journal = Shelter.all.map{|s| s.absent_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @adopted_journal = Shelter.all.map{|s| s.adopted_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @unavailable_journal = Shelter.all.map{|s| s.unavailable_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @fostered_journal = Shelter.all.map{|s| s.fostered_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @rescued_journal = Shelter.all.map{|s| s.rescued_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @shelters_state = Shelter.all.map{|n| n.state }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse
    @open = User.includes(:open_value).map{|u| u.open_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @plan = User.includes(:plan_value).map{|u| u.plan_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @social = User.includes(:social_value).map{|u| u.social_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @attitude = User.includes(:attitude_value).map{|u| u.attitude_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @emotion = User.includes(:emotion_value).map{|u| u.emotion_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @clean = User.includes(:clean_value).map{|u| u.clean_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @energy = User.includes(:energy_value).map{|u| u.energy_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
  end
end
