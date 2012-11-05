class BreedsController < ApplicationController
  def index
    @breeds = Breed.order(:name).where('name ilike ?', "%#{params[:term]}%")
    render json: @breeds.map(&:name)
  end
end