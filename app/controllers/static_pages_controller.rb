class StaticPagesController < ApplicationController
  
  def home
    respond_to do |format|
      format.mobile {
        render 'splash'
      }
      format.html {
        location = "asdfasdf"
        if cookies[:location]
          location = cookies[:location]
        end
        if (validate_location(location) == false) && (signed_in? and current_user.location?)
        	location = current_user.location
        end
        if validate_location(location) == false    
          s = Geocoder.search(remote_ip)
          location = s[0].city + ", " + s[0].state_code
        end
        cookies[:location] = location
        shelters = Shelter.near(location, 50, order: "distance")
        unless shelters.count > 0
          shelters = Shelter.near(location, 200, order: "distance")
        end
        nearbys = shelters.map{|s| s.id}
        @pets = Pet.order(:name)
        @pets = @pets.where('shelter_id in (?)', nearbys)
        @pets = @pets.select{|p| (p.pet_state.status == 'available' || p.pet_state.status == 'absent')}
        @pets = @pets.sort_by {|s| nearbys.index(s.send(:shelter_id))}
        # select four random pets from list
        #@pets = @pets.sort_by{rand}.first(4)
        @pets = @pets.shuffle!.first(4)
        @pets
        @shelter = shelters.max_by{|s| s.pets.select{|p| (p.pet_state.status == 'available' || p.pet_state.status == 'absent')}.count}
      }
    end
  rescue
    flash[:notice] = "There are no shelters near your location."
    redirect_to findshelter_path
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  def statistics
    if !signed_in?
      redirect_to root_path
    end
  end
end
