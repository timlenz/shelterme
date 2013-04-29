class PetsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :edit]
  before_filter :find_pet, only: [:show, :edit, :update, :destroy]
  
  respond_to :html, :js
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  def new
    @shelters = Shelter.all
    @pet = Pet.new
    @pet.animal_code = cookies[:animal_ID]
    @pet.pet_state_id = PetState.first.id
    @current_location = "asdfasdf"
    if cookies[:location]
      @current_location = cookies[:location]
    end
    if (validate_location(@current_location) == false) && (signed_in? and current_user.location?)
      @current_location = current_user.location
    end
    if validate_location(@current_location) == false    
      flash[:notice] = "Estimating your location."
      s = Geocoder.search(remote_ip)
      if s[0].city != ""
        @current_location = s[0].city + ", " + s[0].state_code
      end
    end
    @nearbys = Array.new
    @nearbys = Shelter.near(@current_location, 50, order: "distance").limit(15)
    if cookies[:recent_shelter_id].to_i > 0
      recent_shelter = Shelter.all.find{|s| s.id == cookies[:recent_shelter_id].to_i}
      if @nearbys.count > 0
        @nearbys.unshift(recent_shelter)
        @nearbys.uniq_by!{|s| s.id }
      else
        @nearbys = @nearbys << recent_shelter
      end
    end
    # if pets with same ID have been found, remove their shelters from the list of available shelters
    if !cookies[:exclude_shelters].blank? && cookies[:exclude] != "false"
      exclude_shelters = cookies[:exclude_shelters].split(" ").map{|s| s.to_i}.uniq
      exclude_shelters = exclude_shelters.map{|s| Shelter.select{|x| x.id == s}}.flatten
      @nearbys = @nearbys.reject{|s| exclude_shelters.include? s }
    end
    # can't add a pet if there aren't any shelters available
    if @nearbys.count == 0
      flash[:notice] = "There are no shelters nearby. Please either change your location or add a shelter below."
      redirect_to findshelter_path
    end
    cookies[:exclude] = ""
  rescue
    flash[:error] = "Unable to create new pet."
    ErrorMailer.error_notification($!).deliver
    redirect_to :back
  end

  def create
    # Because of the shelter/pet nested routing, must create pet from shelter rather than user
    @shelter = Shelter.find(params[:pet][:shelter_id])
    @pet = @shelter.pets.create(params[:pet])
    $exclude_shelter = []
    cookies[:exclude_shelters] = ""
    if @pet.save
      @pet.journalize!(@pet.shelter, @pet.pet_state, nil) # record pet state to journal ("available" by default)
      flash[:success] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} has been added"
      redirect_to [@shelter, @pet]
    else
      flash[:error] = "Please enter all required information."
      render 'new'
    end
  rescue
    flash[:error] = "Unable to save pet. Please resubmit."
    ErrorMailer.error_notification($!).deliver
    render 'new'
  end
    
  def addpet
    if signed_in?
      cookies[:animal_ID] = ''
      if params[:search].present?
        cookies[:animal_ID] = params[:search].parameterize.titleize.gsub(" ","")
        @pets = Pet.select{|p| p.animal_code == cookies[:animal_ID] }
        if @pets.count > 0
          render 'add_found'
          $exclude_shelter = @pets.map{|p| p.shelter }
          cookies[:exclude_shelters] = @pets.map{|p| p.shelter.id.to_s}
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
  
  def find
    if params[:location].present?
      @current_location = params[:location]
    elsif cookies[:location]
      @current_location = cookies[:location]
    elsif signed_in? and current_user.location?
      @current_location = current_user.location
    else      
      s = Geocoder.search(remote_ip)
      @current_location = s[0].city + ", " + s[0].state_code
    end
    if params[:find]
      #@pets = Pet.search(params[:search]).select{|p| p.pet_state.status == "available"}
      @pets = Pet.select{|p| p.pet_state.status == "available"}.first(10)
    end
    @pets = Pet.select{|p| p.pet_state.status == "available"}
    @pets = @pets.select{|p| p.species.name == 'dog'}
    @pets = @pets.select{|p| p.pet_photos.present?}
  rescue
    flash[:error] = "Unable to find pets."
    redirect_to :back
  end
  
  def show
    cookies[:pet_id] = @pet.id
    canonical_url(pet_url(@pet))
    @microposts = @pet.microposts
    @feed_items = @pet.feed
    cookies[:delete_managed_pet] = "false"
    if signed_in?
      @micropost = current_user.microposts.build(pet_id: @pet.id)
    end
    if cookies[:history]
      cookies.permanent[:history] = cookies[:history] + " " + @pet.id.to_s
    else
      cookies.permanent[:history] = " "
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
    nearbys = Shelter.near(@current_location, 50, order: "distance").map{|s| s.id}
    unless nearbys.count > 0
      nearbys = Shelter.near(@current_location, 200, order: "distance").map{|s| s.id}
    end
    if nearbys.count > 0
      pets = Pet.order(:name)
      pets = pets.where('shelter_id in (?)', nearbys)
      pets = pets.select{|p| p.pet_state.status == "available"}
      @pet = pets[Random.rand(0..(pets.count-1))]
      flash[:notice] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} is your featured pet for the day."
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
    cookies[:managed_pets] = "false"
    if cookies[:location]
      @current_location = cookies[:location]
    end
    if (@current_location && (validate_location(@current_location) == false))
      if @pet
        @current_location = @pet.shelter.city + ", " + @pet.shelter.state
      else
        @current_location = current_user.location
      end
    end
    @nearbys = Shelter.near(@current_location, 50, order: "distance").limit(5)
    if cookies[:recent_shelter_id].to_i > 0
      recent_shelter = Shelter.all.find{|s| s.id == cookies[:recent_shelter_id].to_i}
      if @nearbys.count > 0
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
  rescue
    flash[:error] = "Unable to edit #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    redirect_to :back
  end
  
  def index
    if signed_in? && current_user.admin?
      cookies[:managed_pets] = "true"
      @pets = Pet.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
    else
      redirect_to root_path
    end
  rescue  
    @pets = Pet.search(params[:search]).sort_by{|p| p[sort_column]}
    if sort_direction == "desc"
      @pets = @pets.reverse
    end
    @pets = @pets.paginate(page: params[:page])
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def sort_column
    Pet.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def update
    if @pet.update_attributes(params[:pet])
      if cookies[:managed_pets] == "true"
        @pet.journalize!(@pet.shelter, @pet.pet_state, old_pet_state: cookies[:pet_state_change])
        flash[:success] = "#{@pet.name != "" ? @pet.name : @pet.animal_code}'s status has been updated."
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
      render 'edit'
    end
  rescue
    flash[:error] = "Unable to update #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    redirect_to :back
  end
  
  def destroy
    @pet.destroy
    flash[:notice] = "#{@pet.name != "" ? @pet.name : @pet.animal_code} has been deleted."
    if cookies[:delete_managed_pet] == "true"
      redirect_to :back
      cookies[:delete_managed_pet] = "false"
    else
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to delete #{@pet.name != "" ? @pet.name : @pet.animal_code}."
    redirect_to :back
  end
  
  private
  
    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
    
    def find_pet
      @pet = Pet.find_by_slug(params[:id])
    end
end

