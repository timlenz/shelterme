class UsersController < ApplicationController
  before_filter :signed_in_user, 
                only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  
  helper_method :sort_column, :sort_direction
  
  autocomplete :shelter, :name, full: true
  
  respond_to :html, :js, only: [:matchme, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts#.paginate(page: params[:page])
  end
  
  def index
    if signed_in?
      if current_user.admin?
        @users = User.search(params[:search]).order(sort_column + ' ' + sort_direction).paginate(page: params[:page])
      end
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
      redirect_to root
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
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "#{@user.name} has been destroyed."
    redirect_to root_path
  end
  
  def update
    if @user.update_attributes(params[:user])
      if current_user == @user
        if $match == true
          sign_in @user
          #redirect_to matchme_path
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
  end
  
  def matchme
    @user = current_user
    if location.present?
      @current_location = location
    elsif signed_in? and current_user.location?
      @current_location = current_user.location
    else      
      s = Geocoder.search(remote_ip)
      @current_location = s[0].city + ", " + s[0].state_code
    end
    @current_location
    @user.matchme
  end
  
  def sponsored
    @user = current_user
  end

  def followed
    @user = current_user
  end
  
  def activity
    @user = current_user
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
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
end