class PetPhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js
  
  def new
    @pet_photo = PetPhoto.new(pet_id: $pet.id)
    cookies[:photo] = "new"
  end

  def create
    @pet_photo = PetPhoto.new(params[:pet_photo])
    if $pet.pet_photos.size == 0
      @pet_photo.primary = true
    end
    if @pet_photo.save
      render :crop
    else
      flash[:error] = "Whoops. The photo of #{$pet.name != "" ? $pet.name : $pet.animal_code} was not added."
      redirect_to [$pet.shelter, $pet]
    end
  end

  def edit
    @pet_photo = PetPhoto.find(params[:id])
    unless cookies[:photo] == "new"
      cookies[:photo] = "edit"
    end
  end

  def update
    @pet_photo = PetPhoto.find(params[:id])
    unless cookies[:photo] == "new"
      PetPhoto.select{|pp| @pet_photo.pet.id == pp.pet.id }.each{|pp| pp.primary = false }.each(&:save)
      @pet_photo.primary = true
    end
    if @pet_photo.update_attributes(params[:pet_photo])
      if cookies[:photo] == "new"
        flash[:notice] = "Photo of #{$pet.name != "" ? $pet.name : $pet.animal_code} added."
        redirect_to [$pet.shelter, $pet]
      else
        flash[:notice] = "Updated the primary photo for #{$pet.name != "" ? $pet.name : $pet.animal_code}."
        redirect_to edit_shelter_pet_path($pet.shelter, $pet)
      end
    else
      flash[:error] = "The photo of #{$pet.name != "" ? $pet.name : $pet.animal_code} was not updated."
      if cookies[:photo] == "edit"
        redirect_to edit_shelter_pet_path($pet.shelter, $pet)
      else
        redirect_to [$pet.shelter, $pet]
      end
    end
    cookies[:photo] = ""
  end

  def destroy
    @pet_photo = PetPhoto.find(params[:id])
    @pet_photo.destroy
    if @pet_photo.primary == true
      new_primary = @pet_photo.pet.pet_photos.select{|p| p != @pet_photo}.first
      new_primary.primary = true
      new_primary.save
    end
    flash[:notice] = "Photo of #{$pet.name != "" ? $pet.name : $pet.animal_code} deleted."
    redirect_to edit_shelter_pet_path($pet.shelter, $pet)
  end

end
