class PetVideosController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  respond_to :html, :js

  def new
    @pet_video = PetVideo.new(pet_id: $pet.id)
  end

  def create
    @pet_video = PetVideo.create!(params[:pet_video])
    redirect_to $pet 
  end
  
  def destroy
    @pet_video = PetVideo.find(params[:id])
    Panda::Video.delete(@pet_video.panda_video_id)
    @pet_video.destroy
    flash[:notice] = "Video of #{$pet.name} deleted."
    redirect_to edit_pet_path($pet)
  end
end
