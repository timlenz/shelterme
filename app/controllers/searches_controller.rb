class SearchesController < ApplicationController
  
  respond_to :html, :js
  
  $search = Search.first
  
  def new
    if $search and ($search.created_at > 1.second.ago or $search.updated_at > 1.second.ago)
      @search = $search
      @current_location = $search.location
    else
      @reset = true
      @search = Search.new
      @current_location = "asdfasdf"
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
        flash[:notice] = "Invalid location; estimating your location instead."
        s = Geocoder.search(remote_ip)
        if s[0].city != ""
          @current_location = s[0].city + ", " + s[0].state_code
        end
      end
      cookies[:location] = @current_location
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
    @local_sb = @search.local_species.select{|p| p.primary_breed_id == @search.breed_id || p.secondary_breed_id == @search.breed_id}
    @local_sbg = @local_sb.select{|p| p.gender_id == @search.gender_id}
    @local_sbga = @local_sbg.select{|p| p.age_group == @search.age_group}
    @local_sbgas = @local_sbga.select{|p| p.size_id == @search.size_id}
    @local_sbgasa = @local_sbgas.select{|p| p.affection_id == @search.affection_id}
    @local_sbgasan = @local_sbgasa.select{|p| p.nature_id == @search.nature_id}
    render :new
  rescue
    flash[:notice] = "No shelters within 200 miles of #{@search.location}."
    redirect_to findshelter_path
  end
end