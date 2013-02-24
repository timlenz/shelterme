class PetPhotosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js
  
  def new
    @pet_photo = PetPhoto.new(pet_id: $pet.id)
    cookies[:photo] = "new"
  end

  def create
    @pet_photo = PetPhoto.create!(params[:pet_photo])
    if $pet.pet_photos.size == 0
      @pet_photo.primary = true
    end
    if @pet_photo.save
      render :crop
    else
      flash[:error] = "Whoops. The photo of #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code} was not added."
      redirect_to [@pet_photo.pet.shelter, @pet_photo.pet]
    end
  rescue
    flash[:error] = "Unable to add photo for #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code}."
    redirect_to [@pet_photo.pet.shelter, @pet_photo.pet]
  end

  def edit
    @pet_photo = PetPhoto.find(params[:id])
    unless cookies[:photo] == "new"
      cookies[:photo] = "edit"
    end
  rescue
    flash[:error] = "Unable to edit photo for #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code}."
    redirect_to :back
  end

  def update
    @pet_photo = PetPhoto.find(params[:id])
    unless cookies[:photo] == "new"
      PetPhoto.select{|pp| @pet_photo.pet.id == pp.pet.id }.each{|pp| pp.primary = false }.each(&:save)
      @pet_photo.primary = true
    end
    if @pet_photo.update_attributes(params[:pet_photo])
      if cookies[:photo] == "new"
        redirect_to [@pet_photo.pet.shelter, @pet_photo.pet]
        flash[:notice] = "Photo of #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code} added."
      else
        flash[:notice] = "Updated the primary photo for #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code}."
        redirect_to edit_shelter_pet_path(@pet_photo.pet.shelter, @pet_photo.pet)
      end
    else
      flash[:error] = "The photo of #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code} was not updated."
      if cookies[:photo] == "edit"
        redirect_to edit_shelter_pet_path(@pet_photo.pet.shelter, @pet_photo.pet)
      else
        redirect_to [@pet_photo.pet.shelter, @pet_photo.pet]
      end
    end
    cookies[:photo] = ""
  rescue
    flash[:error] = "Unable to update photo for #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code}."
    redirect_to :back
  end

  def destroy
    @pet_photo = PetPhoto.find(params[:id])
    @pet_photo.destroy
    if @pet_photo.primary == true
      new_primary = @pet_photo.pet.pet_photos.select{|p| p != @pet_photo}.first
      new_primary.primary = true
      new_primary.save
    end
    flash[:notice] = "Photo of #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code} deleted."
    if cookies[:delete_media] == "true"
      redirect_to :back
      cookies[:delete_media] = "false"
    else
      redirect_to edit_shelter_pet_path(@pet_photo.pet.shelter, @pet_photo.pet)
    end
  rescue
    flash[:error] = "Unable to delete photo for #{@pet_photo.pet.name != "" ? @pet_photo.pet.name : @pet_photo.pet.animal_code}."
    redirect_to :back
  end
  
  def index
    if signed_in? && current_user.admin?
      @pet_photos = PetPhoto.all.paginate(page: params[:page], per_page: 12)
    else
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to display pet photos."
    redirect_to root_path
  end

end
