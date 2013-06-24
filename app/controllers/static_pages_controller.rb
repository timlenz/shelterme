class StaticPagesController < ApplicationController
  
  def home
    respond_to do |format|
      format.html {
        require 'open-uri'
        require 'nokogiri'
        if cookies[:featured_pets] && cookies[:featured_shelter] && cookies[:featured_shelter_pets]
          @featured_pets = cookies[:featured_pets].split("&").map{|p| p.to_i}.map{|p| Pet.select{|x| x.id == p}}.flatten
          @shelter = Shelter.where(id: cookies[:featured_shelter].to_i).first
          @shelter_pets = cookies[:featured_shelter_pets].split("&").map{|p| p.to_i}.map{|p| Pet.where(id: p)}.flatten
        else  
          @location = "Los Angeles, CA" # Temporary fix for LA beta - was MapQuest not responding
          if cookies[:location]
            @location = cookies[:location]
          end
          if (validate_location(@location) == false) && (signed_in? and current_user.location?)
            @location = current_user.location
          end
          if validate_location(@location) == false    
            s = Geocoder.search(remote_ip)
            @location = s[0].city + ", " + s[0].state_code
          end
          cookies[:location] = @location
          shelters = Shelter.near(@location, 70, order: "distance")
          unless shelters.count > 0
            shelters = Shelter.near(@location, 200, order: "distance")
          end
          nearbys = shelters.map{|s| s.id}
          @pets = Pet.order(:name)
          @pets = @pets.where('shelter_id in (?)', nearbys)
          @pets = @pets.where(pet_state_id: 1)
          @pets = @pets.where('pet_photos_count > 0') # Don't show any pets without photos
          if @location != "MapQuest not responding"
            @featured_pets = @pets.sample(4)
            @shelter = Shelter.find(@pets.map{|sh| sh.shelter_id}.sample)
            @shelter_pets = @shelter.available.where('pet_photos_count > 0').sample(2)
            # Add cache support for featured shelter across the site - and calculate once per day per location (if possible)
            cookies[:featured_pets] = { value: @featured_pets.map{|p| p.id}, expires: 1.day.from_now }
            cookies[:featured_shelter] = { value: @shelter.id, expires: 1.day.from_now }
            cookies[:featured_shelter_pets] = { value: @shelter_pets.map{|p| p.id}, expires: 1.day.from_now}
          else
            @featured_pets = []
            @shelter = []
          end
        end
        # TEMPORARY HACK IN LIEU OF TRUE MEMCACHING OF BLOG CONTENT
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
    @featured_pets = []
    @shelter = []
  #rescue
    #flash[:notice] = "There are no shelters near your location."
    #redirect_to findshelter_path and return
  end
  
  def about
  end
  
  def statistics
    if !signed_in?
      redirect_to root_path
    end
    pets = Pet.all
    users = User.all
    @names = pets.map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @dog_names = pets.where(species_id: 2).map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @cat_names = pets.where(species_id: 1).map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @available_journal = Shelter.all.map{|s| s.available_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @absent_journal = Shelter.all.map{|s| s.absent_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @adopted_journal = Shelter.all.map{|s| s.adopted_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @unavailable_journal = Shelter.all.map{|s| s.unavailable_journal}.map{|e| e.split(",").map{|s|s.to_i}}.transpose.map{|x| x.reduce(:+)}.map{|j| j }.join ','
    @shelters_state = Shelter.all.map{|n| n.state }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse
    @open = users.map{|u| u.open_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @plan = users.map{|u| u.plan_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @social = users.map{|u| u.social_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @attitude = users.map{|u| u.attitude_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @emotion = users.map{|u| u.emotion_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @clean = users.map{|u| u.clean_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
    @energy = users.map{|u| u.energy_value}.compact.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.last.first.name
  end
end
