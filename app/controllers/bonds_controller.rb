class BondsController < ApplicationController
  before_filter :signed_in_user

  respond_to :html, :js

  def create
    @pet = Pet.find(params[:bond][:pet_id])
    current_user.watch!(@pet)
    respond_with @pet
  end

  def destroy
    @pet = Bond.find(params[:id]).pet
    current_user.unwatch!(@pet)
    respond_with @pet
  end
end