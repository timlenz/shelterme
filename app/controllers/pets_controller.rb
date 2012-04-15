class PetsController < ApplicationController
  before_filter :signed_in_user, only: [:create]
  
  def new
  end
  
  def show
    @pet = Pet.find(params[:id])
    canonical_url(pet_url(@pet))
  end
  
  def index
    @pets = Pet.paginate(page: params[:page])
  end
  
  def create
    @pet = current_user.pets.build(params[:pet])
    if @pet.save
      flash[:success] = "Pet added"
      redirect_to root_path
    else
      #@feed_items = []
      #render 'static_pages/home'
    end
  end
end
