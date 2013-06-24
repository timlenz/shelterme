class BondsController < ApplicationController
  before_filter :signed_in_user

  respond_to :html, :js

  def create
    @pet = Pet.find(params[:bond][:pet_id])
    if current_user.watching?(@pet)
      flash[:notice] = "You are already following #{ @pet.name ? @pet.name.titleize : @pet.animal_code }."
      respond_with [@pet.shelter, @pet]
    else
      current_user.watch!(@pet)
      respond_with [@pet.shelter, @pet]
    end
  end

  def destroy
    @pet = Bond.find(params[:id]).pet
    current_user.unwatch!(@pet)
    respond_with [@pet.shelter, @pet]
  rescue
    flash[:notice] = "Bond not deleted."
    redirect_to :back
  end
end