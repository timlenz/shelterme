class FavoritesController < ApplicationController
  before_filter :signed_in_user

  respond_to :html, :js

  def create
    @shelter = Shelter.find(params[:favorite][:shelter_id])
    if current_user.boosting?(@shelter)
      flash[:notice] = "You are already following #{@shelter.name}."
      respond_with @shelter
    else
      current_user.boost!(@shelter)
      respond_with @shelter
    end
  end

  def destroy
    @shelter = Favorite.find(params[:id]).shelter
    current_user.unboost!(@shelter)
    respond_with @shelter
  end
end