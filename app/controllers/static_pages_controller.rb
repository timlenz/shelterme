class StaticPagesController < ApplicationController
  
  def home
    respond_to do |format|
      format.html {
        require 'open-uri'
        require 'nokogiri'
        @location = "MapQuest not responding"
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
        shelters = Shelter.near(@location, 50, order: "distance")
        unless shelters.count > 0
          shelters = Shelter.near(@location, 200, order: "distance")
        end
        nearbys = shelters.map{|s| s.id}
        @pets = Pet.order(:name)
        @pets = @pets.where('shelter_id in (?)', nearbys)
        @pets = @pets.select{|p| (p.pet_state.status == 'available' || p.pet_state.status == 'absent')}
        @pets = @pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
        # select four random pets from list
        #@pets = @pets.sort_by{rand}.first(4)
        @pets = @pets.shuffle!.first(4)
        if @location != "MapQuest not responding"
          @pets
          @shelter = shelters.max_by{|s| s.pets.select{|p| (p.pet_state.status == 'available' || p.pet_state.status == 'absent')}.count}
        else
          @pets = []
          @shelter = []
        end
        @blog = true
        blog = Nokogiri::XML(open("http://blog.shelterme.com/feed", read_timeout: 1))
        if blog.nil?
          @blog = false
        else
          first_post = blog.xpath('//item').first
          @title = first_post.xpath('title').inner_text
          @link = first_post.xpath('link').inner_text
          @content = first_post.xpath('description').inner_html
          image = Nokogiri::HTML.parse(first_post.xpath('content:encoded').inner_html).css('img')
          if image.empty?
            @image = "none"
          else
            @image = image.first.attribute("src").text
          end 
        end
      }
    end
  rescue Timeout::Error
    @blog = false
  rescue
    flash[:notice] = "There are no shelters near your location."
    redirect_to findshelter_path and return
  end
  
  def about
  end
  
  def contact
  end
  
  def statistics
    if !signed_in?
      redirect_to root_path
    end
    pets = Pet.all
    users = User.all
    @names = pets.map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @dog_names = pets.select{|p| p.species_id == 2}.map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
    @cat_names = pets.select{|p| p.species_id == 1}.map{|n| n.name }.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse[0..9].select{|p| p[1] > 1}.map{|pn| pn.first}.each{|e| e}.reject{|n| n == "Name"}
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
