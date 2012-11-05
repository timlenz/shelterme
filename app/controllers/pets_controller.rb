class PetsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :edit]
  
  respond_to :html, :js
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  def new
    if signed_in?
      @shelters = Shelter.all
      @pet = Pet.new
      @pet.animal_code = @@pass
      @pet.pet_state_id = PetState.first.id
    else
      redirect_to signin_path
    end
  end

  def create
    @user = current_user
    @pet = @user.pets.create(params[:pet])
    if @pet.save
      flash[:success] = "#{@pet.name} has been added"
      redirect_to @pet
    else
      flash[:error] = "Please enter all required information."
      render 'new'
    end
  end
    
  def addpet
    if params[:search].present?
      @@pass = params[:search]
      @pet = Pet.all.find{|p| p.animal_code == @@pass }
      if !@pet.nil?
        flash[:success] = "#{@pet.animal_code} already has a profile."
        redirect_to @pet
      else
        flash[:error] = "Please create a profile for #{@@pass}. "
        redirect_to newpet_path
      end
    end
  end
  
  def find
    if params[:location].present?
      @current_location = params[:location]
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
  end
  
  def show
    @pet = Pet.find(params[:id])
    $pet = @pet
    canonical_url(pet_url(@pet))
    @microposts = @pet.microposts
    @feed_items = @pet.feed
    if signed_in?
      @micropost = current_user.microposts.build(pet_id: @pet.id)
    end
  end
  
  def potd
    s = Geocoder.search(remote_ip)
    @current_location = s[0].city + ", " + s[0].state_code
    nearbys = Shelter.near(@current_location, 50, order: "distance").map{|s| s.id}
    if nearbys.count > 0
      pets = Pet.order(:name)
      pets = pets.where('shelter_id in (?)', nearbys)
      pets = pets.select{|p| p.pet_state.status == "available"}
      @pet = pets[Random.rand(0..pets.count-1)]
      redirect_to @pet
    else
      flash[:error] = "There are no pets available within 50 miles of you."
      redirect_to root_path
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end
  
  def index
    if signed_in?
      if current_user.admin?
        @pets = Pet.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
      end
    else
      redirect_to root_path
    end
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def sort_column
    Pet.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def update
    @pet = Pet.find(params[:id])
    if @pet.update_attributes(params[:pet])
      flash[:success] = "#{@pet.name} has been updated."
      redirect_to @pet
    else
      render 'edit'
    end
  end
  
  def destroy
    @pet = Pet.find(params[:id])
    @pet.destroy
    flash[:notice] = "#{@pet.name} has been deleted."
    redirect_to root_path
  end
  
  private
  
    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
end

