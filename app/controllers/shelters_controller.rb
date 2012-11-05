class SheltersController < ApplicationController
  #before_filter :admin_user, only: [:edit, :update, :destroy]
  
  helper_method :sort_column, :sort_direction
  
  respond_to :html, :js, only: :show
  
  def new
    @shelter = Shelter.new
  end
  
  def show
    @shelter = Shelter.find(params[:id])
    @available_dogs = @shelter.available_dogs.paginate(page: params[:dogs_page], per_page: 12)
    @available_cats = @shelter.available_cats.paginate(page: params[:cats_page], per_page: 12)
    @adopted = @shelter.adopted.paginate(page: params[:adopted_page], per_page: 12)
    @unavailable = @shelter.unavailable.paginate(page: params[:unavailable_page], per_page: 12)
  end
  
  def create
    @shelter = Shelter.new(params[:shelter])
    if @shelter.save
      flash[:success] = "#{@shelter.name} added to available shelters"
      redirect_to @shelter
    else
      render 'new'
    end
  end
  
  def index
    if signed_in? and current_user.admin?
      @shelters = Shelter.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
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
    @shelter = Shelter.find(params[:id])
  end
  
  def update
    @shelter = Shelter.find(params[:id])
    if @shelter.update_attributes(params[:shelter])
      flash[:success] = "Profile for #{@shelter.name} has been updated."
      redirect_to @shelter
    else
      render 'edit'
    end
  end
  
  def find
    if params[:search].present?
      @current_location = params[:search]
    elsif signed_in? and current_user.location?
      @current_location = current_user.location
    else      
      s = Geocoder.search(remote_ip)
      @current_location = s[0].city + ", " + s[0].state_code
    end
    @nearbys = Shelter.near(@current_location, 30, order: "distance").limit(5) #limit due to Google Static Map API
  end
  
  def destroy
    @shelter = Shelter.find(params[:id])
    # Remove all references to Shelter ID in users table; also remove manager flag for associated users
    User.all.select{|u| u.shelter_id == @shelter.id }.each{|u| u.shelter_id = ""}.each{|u| u.manager = false}.each{|m| m.save}
    @shelter.destroy
    flash[:notice] = "#{@shelter.name} has been deleted."
    redirect_to root_path
  end
  
  private
  
    def admin_user
      redirect_to(root_path) unless signed_in? and current_user.admin?
    end
end
