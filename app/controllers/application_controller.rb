class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  before_filter :handle_mobile
  
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
  end
  
  def validate_location(location) # No support for non-US addresses
    m = Geocoder.search(location)
    if m[0].address == "US"
      return false
    end
    return true
  end

end