class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :set_cache_buster
  #before_filter :handle_mobile RE-ENABLE WHEN MOBILE APPS ARE READY
  
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_error
    rescue_from ActiveRecord::RecordNotFound, with: :routing_error
    rescue_from ActionController::RoutingError, with: :routing_error
    rescue_from ActionController::UnknownController, with: :routing_error
    rescue_from AbstractController::ActionNotFound, with: :routing_error
  end
  
private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def handle_mobile
    request.format = :mobile if mobile_user_agent?
  end
  
  def mobile_user_agent?
    @mobile_user_agent ||= ( request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|Android)/] )
  end
  
  def canonical_url(canonical_url)
    @canonical_url = canonical_url
  end
  
  def remote_ip
    if request.remote_ip == '127.0.0.1'
      # Hard coded remote address for testing
      '65.73.0.1'
    else
      request.remote_ip
    end
  rescue
    flash[:error] = "FreeGeoIP is not responding."
  end
  
  def validate_location(location) # No support for non-US addresses
    m = Geocoder.search(location)
    if m.blank? or m[0].address == "US"
      return false
    end
    return true
  rescue
    flash[:error] = "MapQuest is not responding."
  end
  
  def routing_error(exception)
    logger.warn "#{exception.message}"
    render file: "/errors/404"
  end

  def render_error(exception)
    logger.warn "#{exception.message}"
    ErrorMailer.error_notification(exception,current_user,request.fullpath).deliver
    render file: "/errors/500", layout: false
  end

end