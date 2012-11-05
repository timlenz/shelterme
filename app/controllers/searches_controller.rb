class SearchesController < ApplicationController
  
  respond_to :html, :js
  
  $search = Search.first
  
  def new
    if :reset != true and $search and ($search.created_at > 1.second.ago or $search.updated_at > 1.second.ago)
      @search = $search
      @current_location = $search.location
    else
      @reset = true
      @search = Search.new
      if location.present?
        @current_location = location
      elsif signed_in? and current_user.location?
        @current_location = current_user.location
      else      
        s = Geocoder.search(remote_ip)
        @current_location = s[0].city + ", " + s[0].state_code
      end
      @current_location
    end
  rescue
    flash[:notice] = "Cannot automatically determine your location."
    redirect_to root_path
  end
  
  def update
    @search = $search
    @search.update_attributes(params[:search])
    $search = Search.find(params[:id])
    render :new
  end
  
  def create
    @search = Search.create!(params[:search])
    redirect_to @search
  end
  
  def show
    @search = Search.find(params[:id])
    $search = @search
    @search_results = @search.pets.paginate(page: params[:page], per_page: 12)
    render :new
  end
end