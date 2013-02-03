class PetVideosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js

  def new
    @pet_video = PetVideo.new(pet_id: $pet.id)
  end

  def create
    @pet_video = PetVideo.create!(params[:pet_video])
    if $pet.pet_videos.size == 0
      @pet_video.primary = true
    end
    if @pet_video.save
      flash[:notice] = "Video of #{$pet.name != "" ? $pet.name : $pet.animal_code} added."
    else
      flash[:notice] = "Upload of video failed."
    end
    redirect_to [$pet.shelter, $pet]
  end
  
  def edit
    @pet_video = PetVideo.find(params[:id])
  end
  
  def update
    @pet_video = PetVideo.find(params[:id])
    PetVideo.select{|pp| @pet_video.pet.id == pp.pet.id }.each{|pp| pp.primary = false }.each(&:save)
    @pet_video.primary = true
    if @pet_video.update_attributes(params[:pet_video])
      flash[:notice] = "Updated the primary photo for #{$pet.name != "" ? $pet.name : $pet.animal_code}."
      redirect_to edit_shelter_pet_path($pet.shelter, $pet)
    else
      flash[:error] = "The video of #{$pet.name != "" ? $pet.name : $pet.animal_code} was not updated."
      redirect_to edit_shelter_pet_path($pet.shelter, $pet)
    end
  end
  
  def destroy
    @pet_video = PetVideo.find(params[:id])
    Panda::Video.delete(@pet_video.panda_video_id)
    @pet_video.destroy
    flash[:notice] = "Video of #{@pet_video.pet.name != "" ? @pet_video.pet.name : @pet_video.pet.animal_code} deleted."
    if cookies[:delete_media] == "true"
      redirect_to :back
      cookies[:delete_media] = "false"
    else
      redirect_to edit_shelter_pet_path(@pet_video.pet.shelter, @pet_video.pet)
    end
  end

  def index
    if signed_in? && current_user.admin?
      @pet_videos = PetVideo.all.paginate(page: params[:page], per_page: 12)
    else
      redirect_to root_path
    end
  end
end
