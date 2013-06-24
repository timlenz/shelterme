class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  
  respond_to :html, :js
  
  def create
    @user = User.find(params[:relationship][:followed_id])
    if current_user.following?(@user)
      flash[:notice] = "You are already following #{@user.name}."
      respond_with @user
    else
      current_user.follow!(@user)
      respond_with @user
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
  rescue
    flash[:notice] = "Relationship not deleted."
    redirect_to :back
  end
end