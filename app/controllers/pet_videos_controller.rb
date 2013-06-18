class PetVideosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js

  def new
    @pet = Pet.all.find{|p| p.id == cookies[:pet_id].to_i}
    @pet_video = PetVideo.new(pet_id: @pet.id)
  end

  def create
    @pet_video = PetVideo.create!(params[:pet_video])
    if @pet_video.pet.pet_videos.size == 1
      @pet_video.primary = true
    end
    if @pet_video.save
      flash[:notice] = "Video of #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code} added."
    else
      flash[:notice] = "Upload of video failed."
      # SEND FAILED VIDEO UPLOAD ALERT EMAIL
    end
    redirect_to [@pet_video.pet.shelter, @pet_video.pet]
  rescue
    flash[:error] = "Unable to add video for #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code}."
    redirect_to [@pet_video.pet.shelter, @pet_video.pet]
  end
  
  def edit
    @pet_video = PetVideo.find(params[:id])
  rescue
    flash[:error] = "Unable to edit video for #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code}."
    redirect_to :back
  end
  
  def update
    @pet_video = PetVideo.find(params[:id])
    PetVideo.select{|pp| @pet_video.pet.id == pp.pet.id }.each{|pp| pp.primary = false }.each(&:save)
    @pet_video.primary = true
    if @pet_video.update_attributes(params[:pet_video])
      flash[:notice] = "Updated the primary photo for #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code}."
      redirect_to edit_shelter_pet_path(@pet_video.pet.shelter, @pet_video.pet)
    else
      flash[:error] = "The video of #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code} was not updated."
      redirect_to edit_shelter_pet_path(@pet_video.pet.shelter, @pet_video.pet)
    end
  rescue
    flash[:error] = "Unable to update video for #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code}."
    redirect_to :back
  end
  
  def destroy
    @pet_video = PetVideo.find(params[:id])
    Panda::Video.delete(@pet_video.panda_video_id)
    @pet_video.destroy
    flash[:notice] = "Video of #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code} deleted."
    if cookies[:delete_media] == "true"
      redirect_to :back
      cookies[:delete_media] = "false"
    else
      redirect_to edit_shelter_pet_path(@pet_video.pet.shelter, @pet_video.pet)
    end
  rescue
    flash[:error] = "Unable to delete video for #{@pet_video.pet.name != "" ? @pet_video.pet.name.titleize : @pet_video.pet.animal_code}."
    redirect_to :back
  end

  def index
    if signed_in? && current_user.admin?
      @pet_videos = PetVideo.all.paginate(page: params[:page], per_page: 24)
    else
      redirect_to root_path
    end
  rescue
    flash[:error] = "Unable to display pet videos."
    redirect_to root_path
  end
end
