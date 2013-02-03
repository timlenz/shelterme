class ShelterAdminsController < ApplicationController
  
  autocomplete :shelter, :name, full: true
  
  def new
    if signed_in?
      @shelter_admin = ShelterAdmin.new
      @shelter_admin.user = @user
      @shelter_admin.shelter = Shelter.find(params[:shelter])
    else
      redirect_to signin_path
    end
  end
  
  def create
    @shelter = Shelter.find(params[:shelter_admin][:shelter_id])
    current_user.manage!(@shelter)
    #respond_with @shelter
  end

  def destroy
    @shelter = ShelterAdmin.find(params[:id]).shelter
    current_user.unmanage!(@shelter)
    #respond_with @shelter
  end
  
end