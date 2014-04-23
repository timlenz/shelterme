class SheltersController < ApplicationController
  before_filter :find_shelter, only: [:show, :edit, :update, :destroy]
  
  helper_method :sort_column, :sort_direction
  
  respond_to :html, :js
  
  def new
    @shelter = Shelter.new
  end
  
  def create
    @shelter = Shelter.new(params[:shelter])
    if current_user.admin?
      if @shelter.save
        flash[:success] = "The shelter #{@shelter.name} has been added."
        redirect_to @shelter
      else
        render 'new'
      end
    else
      ShelterMailer.submit_shelter(@shelter, current_user).deliver
      flash[:notice] = "Thank you! We will review the information and inform you when the shelter has been added."
      redirect_to root_path and return
    end
  rescue
    flash[:notice] = "Shelter not created."
    render 'new'
  end
  
  def show
    respond_to do |format|
      format.html {
        @available_dogs = @shelter.available_dogs.paginate(page: params[:dogs_page], per_page: 12)
        @available_cats = @shelter.available_cats.paginate(page: params[:cats_page], per_page: 12)
        @adopted = @shelter.adopted.paginate(page: params[:adopted_page], per_page: 12)
        @unavailable = @shelter.unavailable.paginate(page: params[:unavailable_page], per_page: 12)
        @fostered = @shelter.fostered.paginate(page: params[:fostered_page], per_page: 12)
        @rescued = @shelter.rescued.paginate(page: params[:rescued_page], per_page: 12)
        @managers = @shelter.managers
        cookies[:recent_shelter_id] = @shelter.id
      }
    end
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def index
    if signed_in? && current_user.admin?
      @shelters = Shelter.search(params[:search]).paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end
  
  def list
    @shelters = Shelter.order(:name).where("name ilike ?", "%#{params[:term]}%")
    render json: @shelters.map(&:name)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def sort_column
    Shelter.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
    
  def edit
  end
  
  def update
    if @shelter.update_attributes(params[:shelter])
      flash[:success] = "Profile for #{@shelter.name} has been updated."
      redirect_to @shelter
    else
      render 'edit'
    end
  end
  
  def find
    #
    # Set location for search in a cascade from most specific to least.
    # If one level doesn't exist or fails to validate then go to next:
    # 1) entered value in form
    # 2) value from location cookie
    # 3) current user location
    # 4) geocoder remote ip lookup
    # 5) failure handling of "mapquest not responding"
    #
    @current_location = "MapQuest not responding"
    if params[:search].present?
      @current_location = params[:search]
    end
    if (validate_location(@current_location) == false) && (cookies[:location])
      @current_location = cookies[:location]
    end
    if (validate_location(@current_location) == false) && (signed_in? and current_user.location?)
      @current_location = current_user.location
    end
    if validate_location(@current_location) == false   
      s = Geocoder.search(remote_ip)
      if s[0].city.blank?
        @current_location = s[0].latitude.to_s + ", " + s[0].longitude.to_s
      else
        @current_location = s[0].city + ", " + s[0].state_code
      end
    end
    cookies[:location] = @current_location
    if @current_location != "MapQuest not responding"
      # added ", US" as hack around Geonames location conflation issues
      nearbys = Shelter.near(@current_location + ", US", 70, order: "distance")
      @nearbys = nearbys.limit(5) # limit due to Google Static Map API restriction
      @all_nearbys = nearbys - @nearbys
    else
      @nearbys = []
      @all_nearbys = []
    end
  rescue
    flash[:notice] = "Cannot determine your location."
  end
  
  def managed
    if signed_in? and current_user.manager?
      sort_arr = ['available', 'absent', 'adopted', 'rescued', 'fostered', 'unavailable']
      @pets = current_user.shelter.pets.includes(:pet_state, :user).search(params[:search]).sort_by { |h| sort_arr.index(h.pet_state.status) }.paginate(page: params[:page])
      # @pets = current_user.shelter.pets.includes(:pet_state, :user).search(params[:search]).paginate(page: params[:page])
      cookies[:managed_pets] == "true"
    elsif signed_in?
      flash[:notice] = "You do not have access to this page."
      redirect_to root_path
    else
      flash[:notice] = "You must be signed in to access this page."
      redirect_to signin_path
    end
  end
  
  def featured
    accessor = request.fullpath.downcase
    shelter = accessor.match(/\/(.*?)\//)[1]
    @shelter = Shelter.where('slug iLIKE ?', "#{shelter}").first
    if accessor == "/agoura/featured"
      @pet = Pet.where('slug iLIKE ?', "Madonna").first
      flash[:notice] = "#{@pet.name ? @pet.name : @pet.animal_id} is the featured pet at #{@shelter.name}."
      redirect_to [@shelter, @pet]
    else
      @pet = @shelter.available.sample(1)
    end
  rescue
    flash[:notice] = "There is no featured pet at #{@shelter.name}."
    redirect_to @shelter
  end
  
  def destroy
    # Remove all references to Shelter ID in users table; also remove manager flag for associated users
    User.all.select{|u| u.shelter_id == @shelter.id }.each{|u| u.shelter_id = ""}.each{|u| u.manager = false}.each{|m| m.save}
    @shelter.destroy
    flash[:notice] = "#{@shelter.name} has been deleted."
    if cookies[:delete_shelter] == "true"
      redirect_to :back
      cookies[:delete_shelter] = "false"
    else
      redirect_to root_path
    end
  rescue
    flash[:notice] = "Shelter not deleted."
    redirect_to :back
  end
  
  private
  
    def admin_user
      redirect_to(root_path) unless signed_in? and current_user.admin?
    end
    
    def find_shelter
      @shelter = Shelter.where('slug iLIKE ?', "#{params[:id]}").first # CASE INSENSITIVE LOOKUP
    end
end
