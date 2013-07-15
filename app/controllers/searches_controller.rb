class SearchesController < ApplicationController
  
  respond_to :html, :js
  
  $search = Search.first
  
  def new
    #
    # Set location for search in a cascade from most specific to least:
    # 1) entered value in form
    # 2) value from location cookie
    # 3) current user location
    # 4) geocoder remote ip lookup
    # 5) failure handling of "mapquest not responding"
    #
    @search = Search.new
    @current_location = "MapQuest not responding"
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
    if $search.blank?
      @search.update_attributes(params[:search])
      $search = Search.find(params[:id])
    else     
      @search = $search
      @search.update_attributes(params[:search])
      $search = Search.find(params[:id])
    end
    render :new
  rescue
    flash[:notice] = "Whoops. That didn't work. Please try again."
    redirect_to findpet_path
  end
  
  def create
    @search = Search.create!(params[:search])
    $search = []
    redirect_to @search
  rescue
    flash[:notice] = "Whoops. That didn't work. Please try again."
    redirect_to findpet_path
  end
  
  def show
    @search = Search.find(params[:id])
    $search = @search
    @search_results = @search.pets.paginate(page: params[:page], per_page: 12)
    render :new
  rescue
    redirect_to :back and return
  end
  
end