class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
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

end