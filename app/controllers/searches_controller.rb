class SearchesController < ApplicationController
  
  respond_to :html, :js
  
  $search = Search.first
  
  def new
    @search = Search.new
    @current_location = "Los Angeles, CA" # Temporary fix for LA beta - was MapQuest not responding
    if location.present?
      @current_location = location
    end
    if (validate_location(@current_location) == false) && (cookies[:location])
      @current_location = cookies[:location]
    end
    if (validate_location(@current_location) == false) && (signed_in? and current_user.location?)
      @current_location = current_user.location
    end
    if validate_location(@current_location) == false  
      s = Geocoder.search(remote_ip)
      if s[0].city != ""
        @current_location = s[0].city + ", " + s[0].state_code
      end
    end
    cookies[:location] = @current_location
  rescue
    flash[:notice] = "Cannot determine your location."
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
    $search = []
    redirect_to @search
  end
  
  def show
    @search = Search.find(params[:id])
    $search = @search
    @search_results = @search.pets.paginate(page: params[:page], per_page: 36)
    if @search.breed_id == nil
      @local_sb = []
    else
      @local_sb = @search.local_species.select{|p| p.primary_breed_id == @search.breed_id || p.secondary_breed_id == @search.breed_id}
    end
    @local_sbg = @local_sb.select{|p| p.gender_id == @search.gender_id}
    @local_sbga = @local_sbg.select{|p| p.age_group == @search.age_group}
    @local_sbgas = @local_sbga.select{|p| p.size_id == @search.size_id}
    @local_sbgasa = @local_sbgas.select{|p| p.affection_id == @search.affection_id}
    @local_sbgasan = @local_sbgasa.select{|p| p.nature_id == @search.nature_id}
    render :new
  end
  
end