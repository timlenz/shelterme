class PetMediaController < ApplicationController
  def new
    @pet_media = PetMedia.new(pet_id: params[:pet_id])
  end
  
  def create
    @pet_media = @pet.pet_media.create!(params[:pet_media])
    if @pet_media.save
      flash[:notice] = "Successfully created pet media."
      redirect_to @pet
    else
      flash[:notice] = "Yeah, that didn't work"
      render action: 'new'
    end
  end
  
  def edit
    @pet_media = PetMedia.find(params[:id])
  end
  
  def update
    @pet_media = PetMedia.find(params[:id])
    if @pet_media.update_attributes(params[:pet_media])
      flash[:notice] = "Successfully updated pet media."
      redirect_to @pet_media.pet
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @pet_media = PetMedia.find(params[:id])
    @pet_media.destroy
    flash[:notice] = "Successfully destroyed pet media."
    redirect_to @pet_media.pet
  end
end
