class PetsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :edit, :new]
  # before_filter :find_pet, only: [:show, :edit, :update, :destroy]
  before_filter :find_pet, only: :show # Move find pet to individual actions because of friendly id slug history
  
  respond_to :html, :js
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  def new
    #
    # Set location in a cascade from most specific to least.
    # If option doesn't exist, or validation of it fails, then move to next.
    # 1) value from location cookie (which can be updated from form)
    # 2) current user location
    # 3) geocoder remote ip lookup
    # 4) failure handling of "mapquest not responding"
    #
    @shelters = Shelter.all
    @pet = Pet.new
    @pet.animal_code = cookies[:animal_ID]
    @pet.pet_state_id = PetState.first.id
    @current_location = "MapQuest not responding"
    if cookies[:location]
      @current_location = cookies[:location]
    end
    if (validate_location(@current_location) == false) && (signed_in? and current_user.location?)
      @current_location = current_user.location
    end
    if validate_location(@current_location) == false    
      s = Geocoder.search(remote_ip)
      if s[0].city != ""
        @current_location = s[0].city + ", " + s[0].state_code
      end
    end
    @nearbys = Array.new
    @nearbys = Shelter.near(@current_location + ", US", 20, order: "distance").limit(15)
    # added ", US" as hack around Geonames location conflation issues
    if cookies[:recent_shelter_id].to_i > 0
      recent_shelter = Shelter.where(id: cookies[:recent_shelter_id].to_i).first
      if @nearbys.size > 0
        @nearbys.unshift(recent_shelter)
        @nearbys.uniq_by!{|s| s.id }
      else
        @nearbys = @nearbys << recent_shelter
      end
    end
    # Check for restricted access shelters and remove from list if current user not a manager there (non-admin users)
    if @nearbys.find{|s| s.access == true} && !current_user.admin?
      # Check if current user is a manager for a restricted shelter in the list
      if current_user.manager? && @nearbys.select{|s| s.access == true}.map{|i| i.id}.include?(current_user.shelter_id)
        # Eliminate all restricted shelters for which the current user is not a manager
        @nearbys = @nearbys.reject!{|s| s.access == true && s.id != current_user.shelter_id}
      else
        # Otherwise, eliminate all restricted shelters
        @nearbys.reject!{|s| s.access == true}
      end
    end
    # if pets with same ID have been found, remove their shelters from the list of available shelters
    unless cookies[:exclude_shelters].blank?
      exclude_shelters = cookies[:exclude_shelters].split("&").map{|s| s.to_i}.uniq
      exclude_shelters = exclude_shelters.map{|s| Shelter.select{|x| x.id == s}}.flatten
      @nearbys.reject!{|s| exclude_shelters.include? s }
    end
    # can't add a pet if there aren't any shelters available
    if @nearbys.size == 0
      flash[:notice] = "There are no shelters nearby. Please either change your location or add a shelter below."
      redirect_to findshelter_path
    end
  rescue
    flash[:error] = "Unable to create new pet."
    ErrorMailer.error_notification($!,current_user,request.fullpath).deliver
    redirect_to :back
  end

  def create
    # Check to see if user has navigated backwards to new pet form before resubmitting
    if cookies[:duplicate_pet] == "true"
      flash[:notice] = "#{params[:pet][:name] != "" ? params[:pet][:name] : params[:pet][:animal_code]} has been added already."
      @shelter = Shelter.find(params[:pet][:shelter_id])
      redirect_to @shelter and return
    else
      # Because of the shelter/pet nested routing, must create pet from shelter rather than user
      @shelter = Shelter.find(params[:pet][:shelter_id])
      @pet = @shelter.pets.create(params[:pet])
      if @pet.save
        cookies[:exclude_shelters] = ""
        cookies[:duplicate_pet] = "true"
        @pet.journalize!(@pet.shelter, @pet.pet_state, nil) # record pet state to journal ("available" by default)
        flash[:success] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} has been added."
        redirect_to [@shelter, @pet]
      else
        flash[:error] = "Please enter all required information."
        render 'new'
      end
    end
  rescue
    flash[:error] = "Unable to create pet."
    ErrorMailer.error_notification($!,current_user,request.fullpath).deliver
    redirect_to addpet_path
  end
    
  def addpet
    if signed_in?
      cookies[:animal_ID] = ''
      cookies[:duplicate_pet] = "false"
      if params[:search].present?
        cookies[:animal_ID] = params[:search]#.parameterize.titleize.gsub(" ","")
        # Check for match with end of animal ID, not including first character
        @pets = Pet.includes(:shelter, :pet_state, :age_period, :gender, :size, :species, :secondary_color, :fur_length, :primary_color, :energy_level, :nature, :affection, :secondary_breed, :primary_breed).where('animal_code LIKE ?', "%#{cookies[:animal_ID][1..-1]}")
        @exact_pets = Pet.where('animal_code LIKE ?', "#{cookies[:animal_ID]}")
        if @pets.size > 0
          cookies[:exclude_shelters] = @exact_pets.includes(:shelter).map{|p| p.shelter.id.to_s}
          render 'add_found'
        else
          redirect_to newpet_path
          cookies[:exclude_shelters] = ""
        end
      end
    else
      flash[:notice] = "You must be signed in to access this page."
      redirect_to join_path
    end
  end
  
  def show
    canonical_url(shelter_pet_url(@pet.shelter, @pet))
    cookies[:pet_slug] = @pet.slug
    @microposts = @pet.microposts
    @feed_items = @pet.feed.includes(:user)
    @pet_photos = @pet.pet_photos.includes(:user).sort_by {|p| p.primary ? 0:1 }
    @pet_videos = @pet.pet_videos.includes(:user).sort_by {|p| p.primary ? 0:1 }
    cookies[:delete_managed_pet] = "false"
    if signed_in?
      @micropost = current_user.microposts.build(pet_id: @pet.id)
    end
    if cookies[:history]
      cookies.permanent[:history] = cookies[:history] + " " + @pet.id.to_s
    else
      cookies.permanent[:history] = @pet.id.to_s
    end   
    if request.original_url != @canonical_url # redirect messy Facebook share URLs to clean system version
      redirect_to [@pet.shelter, @pet]
    end
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def potd
    accessor = request.fullpath
    if accessor == "/potd"
      s = Geocoder.search(remote_ip)
      @current_location = s[0].city + ", " + s[0].state_code
    elsif accessor == "/la"
      @current_location = "Los Angeles"
    end
    nearbys = Shelter.near(@current_location + ", US", 20, order: "distance").map{|s| s.id}
    unless nearbys.size > 0
      nearbys = Shelter.near(@current_location + ", US", 100, order: "distance").map{|s| s.id}
    end
    if nearbys.size > 0
      pets = Pet.order(:name) # IS THIS NECESSARY?
      pets = pets.where('shelter_id in (?)', nearbys).where(pet_state_id: 1).where('pet_photos_count > 0')
      @pet = pets[Random.rand(0..(pets.size-1))]
      flash[:notice] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} is your featured pet."
      redirect_to [@pet.shelter, @pet]
    else
      flash[:error] = "There are no pets available near you."
      redirect_to root_path
    end
  rescue  
    flash[:error] = "There are no pets available near you."
    redirect_to root_path
  end

  def edit
    @pet = Pet.find params[:id]
    #
    # Set location for pet in a cascade from most specific to least:
    # 1) value from location cookie
    # 2) current pet location
    # 3) current user location
    #
    cookies[:managed_pets] = "false"
    cookies[:photo] = "edit"
    @pet_photos = @pet.pet_photos.includes(:user).sort_by {|p| p.primary ? 0:1 }
    @pet_videos = @pet.pet_videos.includes(:user).sort_by {|p| p.primary ? 0:1 }
    if !cookies[:location].blank?
      @current_location = cookies[:location]
    elsif @pet
      @current_location = @pet.shelter.city + ", " + @pet.shelter.state
    else
      @current_location = current_user.location
    end
    @nearbys = Shelter.near(@current_location + ", US", 20, order: "distance")
    if cookies[:recent_shelter_id].to_i > 0
      recent_shelter = Shelter.where(id: cookies[:recent_shelter_id].to_i).first
      if @nearbys.size > 0
        @nearbys.unshift(recent_shelter)
        @nearbys.uniq_by!{|s| s.id }
      else
        @nearbys = @nearbys << recent_shelter
      end
    end
    shelter_check = @nearbys.find{|s| s.id == @pet.shelter.id }
    unless shelter_check
      @nearbys = @nearbys << @pet.shelter
    end
    # Check for restricted access shelters and remove from list if current user not a manager there (non-admin users)
    if @nearbys.find{|s| s.access == true} && !current_user.admin?
      # Check if current user is a manager for a restricted shelter in the list
      if @nearbys.select{|s| s.access == true}.map{|i| i.id}.include?(current_user.shelter_id)
        # Eliminate all restricted shelters for which the current user is not a manager
        @nearbys = @nearbys.reject!{|s| s.access == true && s.id != current_user.shelter_id}
      else
        # Otherwise, eliminate all restricted shelters
        @nearbys.reject!{|s| s.access == true}
      end
    end
  rescue
    if @pet
      flash[:error] = "Unable to edit #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    else
      flash[:error] = "Unable to edit pet."
    end  
    redirect_to :back
  end
  
  def index
    if signed_in? && current_user.admin?
      cookies[:managed_pets] = "true"
      sort_arr = ['available', 'absent', 'adopted', 'rescued', 'fostered', 'unavailable']
      @pets = Pet.includes(:user, :pet_state).search(params[:search]).sort_by { |h| sort_arr.index(h.pet_state.status) }.paginate(page: params[:page])
    else
      redirect_to root_path
    end
  rescue  
    redirect_to :back
    flash[:notice] = "Unable to display list of pets."
  end
  
  def update
    @pet = Pet.find params[:id]
    if @pet.update_attributes(params[:pet])
      if cookies[:managed_pets] == "true"
        @pet.journalize!(@pet.shelter, @pet.pet_state, old_pet_state: cookies[:pet_state_change])
        redirect_to :back
      else
        # if pet state has changed, then journalize
        if cookies[:pet_state_change] != "false"
          @pet.journalize!(@pet.shelter, @pet.pet_state, old_pet_state: cookies[:pet_state_change])
          cookies[:pet_state_change] = "false"
          # alert admin if user submitted absent pet
          if cookies[:absent_pet_submit] == "true"
            PetMailer.absent_pet(@pet,current_user).deliver
            cookies[:absent_pet_submit] = "false"
          end
          flash[:success] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} has been updated."
        end
        redirect_to [@pet.shelter, @pet]
      end
    else
      redirect_to :back
      flash[:error] = "Please enter all required information."
    end
  rescue
    if @pet
      flash[:error] = "Unable to update #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    else
      flash[:error] = "Unable to update pet."
    end  
    # ErrorMailer.error_notification($!,current_user,request.fullpath).deliver
    redirect_to :back
  end
  
  def destroy
    @pet = Pet.find params[:id]
    if signed_in? && current_user.admin?
      @pet.destroy
      flash[:notice] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} has been deleted."
      if cookies[:delete_managed_pet] == "true"
        redirect_to :back
        cookies[:delete_managed_pet] = "false"
      else
        redirect_to root_path
      end
    else
      flash[:error] = "Unable to delete pet."
      redirect_to :back
    end
  rescue
    if @pet
      flash[:error] = "Unable to delete #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    else
      flash[:error] = "Unable to delete pet."
    end  
    redirect_to :back
  end
  
  private
  
    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
  
    def sort_column
      Pet.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def find_pet
      # @pet = Pet.where('slug iLIKE ?', "#{params[:id]}").first # CASE INSENSITIVE LOOKUP
      # now uses Friendly ID's modified finder method
      @pet = Pet.find params[:id]
      if request.path != shelter_pet_path(@pet.shelter, @pet)
        redirect_to shelter_pet_path(@pet.shelter, @pet), status: :moved_permanently
        flash[:notice] = "#{@pet.name} is the new name for #{request.path.gsub(/.*\//, '').gsub(/\d*\z/, '').titleize.rstrip}."
      end
    rescue
      @pet = Pet.find params[:id].downcase
    end
end

