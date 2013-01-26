class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :find_user, only: [:show, :destroy]
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  respond_to :html, :js, only: [:matchme, :update]
  
  def show
    @microposts = @user.microposts
  end
  
  def index
    if signed_in? && current_user.admin?
      @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
    else
      redirect_to root_path
    end
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
  def sort_column
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
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
      $match = false
      if @user.save
        sign_in @user
        redirect_to @user
      else
        render 'new'
      end
    else
      redirect_to root
    end
  end
  
  def edit
    $match = false
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name} has been destroyed."
    redirect_to root_path
  end
  
  def update
    if @user.update_attributes(params[:user])
      if current_user == @user
        if $match == true
          sign_in @user
          render :matchme
          return
        end
        flash[:success] = "Your profile has been updated."
        sign_in @user
      else
        flash[:success] = "Profile for #{@user.name} has been updated."
      end  
      redirect_to @user
    else
      render 'edit'
    end
    cookies.delete :location
  end
  
  def matchme
    if signed_in?
      @user = current_user
      @current_location = "asdfasdf"
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
        flash[:notice] = "Invalid location; estimating your location instead."
        s = Geocoder.search(remote_ip)
        if s[0].city != ""
          @current_location = s[0].city + ", " + s[0].state_code
        end
      end
      @user.matchme
      cookies[:location] = @current_location
    else
      flash[:notice] = "Cannot automatically determine your location."
      redirect_to join_path
    end
  end
  
  def sponsored
    @user = current_user
  end

  def followed
    @user = current_user
  end
  
  def relationships
    @user = current_user
  end
  
  def photos
    @user = current_user
    @photos = PetPhoto.select{|u| u.user == @user}
  end
  
  def videos
    @user = current_user
    @videos = PetVideo.select{|u| u.user == @user}
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
    
    def sort_column
      params[:sort] || "name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
    
    def find_user
      @user = User.find_by_slug(params[:id])
    end
end