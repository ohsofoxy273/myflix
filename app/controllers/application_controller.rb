class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SessionsHelper
  
  def require_user
  	redirect_to new_session_path unless logged_in?	
  end
end
