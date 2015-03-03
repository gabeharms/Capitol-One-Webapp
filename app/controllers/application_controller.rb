class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include CustomerSessionsHelper
  include EmployeeSessionsHelper
  
  # Confirms a logged-in user.
    def logged_in_customer
      unless customer_logged_in?
        store_location
        flash[:danger] = "Please log in1."
        redirect_to customer_login_url
      end
    end
    
    def current_user
      current_customer
    end

    def user_signed_in?
      customer_logged_in?
    end
helper_method :current_user
helper_method :user_signed_in?


end
