class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :find_user, only: [:show, :destroy]
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  respond_to :html, :js, only: [:matchme, :update]
  
  def show
    @microposts = @user.microposts.includes(:user, pet: :shelter).paginate(page: params[:microposts_page], per_page: 36)
    @sponsored = @user.pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed).paginate(page: params[:sponsored_page], per_page: 12)
    @watched = @user.watched_pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed).paginate(page: params[:watched_page], per_page: 12)
    #@followed = @user.followed_users.paginate(page: params[:followed_page], per_page: 12)
    cookies[:matchme] = "false"
    if @user.shelter.blank?
      @pseudo_boosted = (@user.watched_pets.includes(:shelter).map{|p| p.shelter} + @user.pets.includes(:shelter).map{|p| p.shelter})
    else
      @pseudo_boosted = @user.watched_pets.includes(:shelter).map{|p| p.shelter} + @user.pets.includes(:shelter).map{|p| p.shelter} << @user.shelter
    end
    @pseudo_boosted = @pseudo_boosted.inject(Hash.new(0)) {|hash, val| hash[val] += 1; hash}.entries.sort_by{|k,v| v}.reverse.map{|k,v| k}.compact
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def index
    if signed_in? && current_user.admin?
      @users = User.search(params[:search]).paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end
  
  def managers
    if signed_in?
      if current_user.admin?
        @shelter_admins = User.search(params[:search]).where(manager: true).includes(:shelter).paginate(page: params[:page])
      end
    else
      redirect_to root_path
    end
  end
  
  def new
    unless signed_in?
      @user = User.new
    else
      redirect_to root_path
    end
  end
  
  def create
    unless signed_in?
      @user = User.new(params[:user])
      cookies[:matchme] = "false"
      if @user.save
        sign_in @user
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to root_path
    end
  end
  
  def edit
    cookies[:matchme] = "false"
    cookies[:avatar] = "false"
  rescue
    flash[:error] = "Unable to edit user profile."
    redirect_to :back
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name} has been deleted."
    redirect_to :back
  rescue
    flash[:notice] = "User not deleted."
    redirect_to :back
  end
  
  def update
    if @user.update_attributes(params[:user])
      if current_user == @user
        if cookies[:matchme] == "true"
          sign_in @user
          render :matchme
          cookies[:matchme] = "false"
          return
        end
        if cookies[:avatar] == "false"        
          redirect_to @user
          flash[:success] = "Your profile has been updated."
        else
          cookies[:avatar] = "false"
          redirect_to :back
          flash[:success] = "Your avatar has been updated."
        end
        sign_in @user
      else
        flash[:success] = "Profile for #{@user.name} has been updated."
        redirect_to @user
      end
    else
      render 'edit'
    end
    cookies.delete :location
  rescue
    flash[:notice] = "User not updated."
    redirect_to :back
  end
  
  def matchme
    #
    # Set location for search in a cascade from most specific to least.
    # If one level doesn't exist or fails to validate then go to next:
    # 1) entered value in form
    # 2) value from location cookie
    # 3) current user location
    # 4) geocoder remote ip lookup
    # 5) failure handling of "mapquest not responding"
    #
    if signed_in?
      @user = current_user
      cookies[:matchme] = "false"
      @current_location = "MapQuest not responding"
      if location.present?
        @current_location = location
      end
      if (validate_location(@current_location) == false) && (cookies[:location])
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
      # Call explicit @user.matchme functionality here rather than in matched_pets partial
      cookies[:location] = @current_location
    else
      flash[:notice] = "You must be signed in to access this page."
      redirect_to join_path
    end
  rescue
    flash[:error] = "Unable to find a match for you."
    redirect_to :back
  end
  
  def sponsored
    @user = current_user
    @pets = @user.pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :shelter, :primary_color, :secondary_color, :age_period)
    @petsCount = @pets.size
    @pets = @pets.paginate(page: params[:page], per_page: 12)
  end

  def followed
    @user = current_user
    @pets = @user.watched_pets.includes(:pet_state, :gender, :size, :species, :fur_length, :energy_level, :nature, :affection, :secondary_breed, :primary_breed, :shelter, :primary_color, :secondary_color, :age_period)
    @petsCount = @pets.size
    @pets = @pets.paginate(page: params[:page], per_page: 12)
  end
  
  def relationships
    @user = current_user
  end
  
  def photos
    @user = current_user
    @photos = PetPhoto.where(user_id: @user.id).includes(pet: :user).includes(pet: :shelter).paginate(page: params[:page], per_page: 12)
  end
  
  def videos
    @user = current_user
    @videos = PetVideo.where(user_id: @user.id).includes(pet: :shelter).paginate(page: params[:page], per_page: 12)
  end
  
  def activity
    @user = current_user
    @activity = @user.activity.paginate(page: params[:page])
  end
  
  def following
    @title = "Following"
    @user = current_user#User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = current_user#User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    
    def correct_user
      @user = User.find_by_slug(params[:id])
      redirect_to(root_path) unless current_user?(@user) or current_user.admin?
    end
    
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def find_user
      #@user = User.where(slug: params[:id]).first
      @user = User.where('slug iLIKE ?', "#{params[:id]}").first # CASE INSENSITIVE LOOKUP
    end
end