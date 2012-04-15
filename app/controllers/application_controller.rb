class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  def canonical_url(canonical_url)
    @canonical_url = canonical_url
  end
end