class PetPhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js
  
  def new
    @pet_photo = PetPhoto.new(pet_id: $pet.id)
  end

  def create
    @pet_photo = PetPhoto.new(params[:pet_photo])
    if $pet.pet_photos.all.size == 0
      @pet_photo.primary = true
    end
    if @pet_photo.save
      render :crop
    else
      flash[:error] = "Whoops. The photo of #{$pet.name} was not added."
      redirect_to $pet
    end
  end

  def edit
    @pet_photo = PetPhoto.find(params[:id])
  end

  def update
    @pet_photo = PetPhoto.find(params[:id])
    if current_user.admin? or current_user == $pet.user
      PetPhoto.select{|pp| @pet_photo.pet.id == pp.pet.id }.each{|pp| pp.primary = false }.each(&:save)
      @pet_photo.primary = true
    end
    if @pet_photo.update_attributes(params[:pet_photo])
      if @pet_photo.primary == false
        flash[:notice] = "Photo of #{$pet.name} added."
        redirect_to $pet
      else
        flash[:notice] = "Updated the primary photo for #{$pet.name}."
        redirect_to edit_pet_path($pet)
      end
    else
      flash[:error] = "Whoops. The photo of #{$pet.name} was not updated."
      redirect_to edit_pet_path($pet)
    end
  end

  def destroy
    @pet_photo = PetPhoto.find(params[:id])
    @pet_photo.destroy
    if @pet_photo.primary == true
      new_primary = @pet_photo.pet.pet_photos.select{|p| p != @pet_photo}.first
      new_primary.primary = true
      new_primary.save
    end
    flash[:notice] = "Photo of #{$pet.name} deleted."
    redirect_to edit_pet_path($pet)
  end
end
