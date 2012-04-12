class SheltersController < ApplicationController
  def new
  end
  
  def show
    @shelter = Shelter.find(params[:id])
  end
  
  def index
    @shelters = Shelter.paginate(page: params[:page])
  end
end
